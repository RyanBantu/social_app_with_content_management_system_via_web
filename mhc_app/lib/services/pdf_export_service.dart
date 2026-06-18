import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfExportService {
  static Rect shareOriginFor(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final origin = box.localToGlobal(Offset.zero);
      return origin & box.size;
    }
    final size = MediaQuery.sizeOf(context);
    return Rect.fromLTWH(size.width / 2, size.height / 2, 1, 1);
  }

  static Future<void> saveAndShare({
    required List<int> bytes,
    required String fileName,
    required BuildContext context,
  }) async {
    final shareOrigin = shareOriginFor(context);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    final xFile = XFile(
      file.path,
      mimeType: 'application/pdf',
      name: fileName,
    );

    final result = await Share.shareXFiles(
      [xFile],
      subject: fileName,
      sharePositionOrigin: shareOrigin,
    );

    if (result.status == ShareResultStatus.dismissed) {
      // User closed share sheet without saving — PDF is still in app documents.
    }
  }
}
