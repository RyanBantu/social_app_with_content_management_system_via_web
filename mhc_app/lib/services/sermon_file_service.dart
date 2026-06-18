import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:archive/archive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/models.dart';
import 'pdf_export_service.dart';

class SermonFileService {
  static Future<String> extractText(SermonNote note) async {
    if (note.bodyText.isNotEmpty) return note.bodyText;
    final path = note.docxAsset;
    if (_isRemote(path)) {
      final res = await http.get(Uri.parse(path));
      if (res.statusCode != 200) return note.summary;
      final archive = ZipDecoder().decodeBytes(res.bodyBytes);
      return _textFromArchive(archive);
    }
    return extractTextFromAsset(path);
  }

  static Future<String> extractTextFromAsset(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final archive = ZipDecoder().decodeBytes(data.buffer.asUint8List());
    return _textFromArchive(archive);
  }

  static bool _isRemote(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  static String _textFromArchive(Archive archive) {
    ArchiveFile? doc;
    for (final file in archive.files) {
      if (file.name == 'word/document.xml') {
        doc = file;
        break;
      }
    }
    if (doc == null) return '';

    final xml = utf8.decode(doc.content as List<int>, allowMalformed: true);
    return _xmlToText(xml);
  }

  static String _xmlToText(String xml) {
    final paragraphs = xml.split(RegExp(r'</w:p>'));
    final lines = <String>[];

    for (final paragraph in paragraphs) {
      final withBreaks = paragraph.replaceAll(
        RegExp(r'<w:br[^>]*/>'),
        '\n',
      );
      final runs = RegExp(r'<w:t[^>]*>([^<]*)</w:t>')
          .allMatches(withBreaks)
          .map((match) => _decodeXml(match.group(1) ?? ''))
          .join();

      final cleaned = runs
          .replaceAll('\u00A0', ' ')
          .replaceAll(RegExp(r'[ \t]+'), ' ')
          .replaceAll(RegExp(r'\n{2,}'), '\n')
          .trim();

      if (cleaned.isNotEmpty) {
        lines.add(cleaned);
      }
    }

    return lines.join('\n\n').trim();
  }

  static String _decodeXml(String value) {
    return value
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&#39;', "'");
  }

  static Future<void> downloadDocx(SermonNote note) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${note.fileName}');
    final path = note.docxAsset;
    if (_isRemote(path)) {
      final res = await http.get(Uri.parse(path));
      if (res.statusCode != 200) return;
      await file.writeAsBytes(res.bodyBytes, flush: true);
    } else {
      final data = await rootBundle.load(path);
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    }
    await OpenFilex.open(file.path);
  }

  static Future<void> downloadPdf(
    SermonNote note,
    String bodyText,
    BuildContext context,
  ) async {
    final shareContext = context;
    final pdf = pw.Document();
    final dateLabel =
        '${note.date.day}/${note.date.month}/${note.date.year}';
    final content = bodyText.isNotEmpty ? bodyText : note.summary;
    final paragraphs =
        content.split(RegExp(r'\n\s*\n')).where((p) => p.trim().isNotEmpty);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(48),
        build: (context) => [
          pw.Text(
            'Mysore Hope Center',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            note.title,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '$dateLabel · ${note.speaker}',
            style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 20),
          ...paragraphs.map(
            (paragraph) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 10),
              child: pw.Text(
                paragraph.trim(),
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
              ),
            ),
          ),
        ],
      ),
    );

    final pdfName = note.fileName.replaceAll('.docx', '.pdf');
    await PdfExportService.saveAndShare(
      bytes: await pdf.save(),
      fileName: pdfName,
      context: shareContext,
    );
  }
}
