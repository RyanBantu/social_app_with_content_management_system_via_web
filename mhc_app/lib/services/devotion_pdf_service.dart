import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/models.dart';
import 'pdf_export_service.dart';

class DevotionPdfService {
  static Future<void> generateAndOpen(
    DailyDevotion devotion,
    bool isKannada,
    BuildContext context,
  ) async {
    final shareContext = context;
    final pdf = pw.Document();

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
            devotion.title(isKannada),
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            devotion.series(isKannada),
            style: const pw.TextStyle(fontSize: 14),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '${devotion.date} · ${devotion.speaker}',
            style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            devotion.verseReference(isKannada),
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex('#FC7961'),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            devotion.verseText(isKannada),
            style: pw.TextStyle(
              fontSize: 14,
              fontStyle: pw.FontStyle.italic,
              lineSpacing: 4,
            ),
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            devotion.reflection(isKannada),
            style: const pw.TextStyle(fontSize: 12, lineSpacing: 5),
          ),
        ],
      ),
    );

    final safeName =
        devotion.titleEn.replaceAll(RegExp(r'[^\w]+'), '_').toLowerCase();
    await PdfExportService.saveAndShare(
      bytes: await pdf.save(),
      fileName: 'devotion_$safeName.pdf',
      context: shareContext,
    );
  }
}
