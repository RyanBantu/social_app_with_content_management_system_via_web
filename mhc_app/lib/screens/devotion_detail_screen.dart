import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../models/models.dart';
import '../providers/app_settings.dart';
import '../services/devotion_pdf_service.dart';
import '../theme/app_colors.dart';

class DevotionDetailScreen extends StatefulWidget {
  const DevotionDetailScreen({super.key});

  @override
  State<DevotionDetailScreen> createState() => _DevotionDetailScreenState();
}

class _DevotionDetailScreenState extends State<DevotionDetailScreen> {
  bool _downloading = false;

  Future<void> _downloadPdf(AppSettings settings, DailyDevotion devotion) async {
    setState(() => _downloading = true);
    try {
      await DevotionPdfService.generateAndOpen(
        devotion,
        settings.isKannada,
        context,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(settings.t('pdfError'))),
        );
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final content = context.watch<ContentProvider>();
    final devotion = content.devotion;
    final isKannada = settings.isKannada;

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.t('dailyDevotion')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    devotion.title(isKannada),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    devotion.series(isKannada),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${devotion.date} · ${devotion.speaker}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              settings.t('todaysVerse'),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 1.2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    devotion.verseReference(isKannada),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '"${devotion.verseText(isKannada)}"',
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.55,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              settings.t('reflection'),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 1.2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              devotion.reflection(isKannada),
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _downloading
                  ? null
                  : () => _downloadPdf(settings, devotion),
              icon: _downloading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download),
              label: Text(settings.t('downloadPdf')),
            ),
          ],
        ),
      ),
    );
  }
}
