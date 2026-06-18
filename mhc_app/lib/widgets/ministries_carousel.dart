import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../widgets/content_image.dart';
import '../models/models.dart';
import '../providers/app_settings.dart';
import '../providers/tab_navigation.dart';
import '../theme/app_colors.dart';

class MinistriesCarousel extends StatefulWidget {
  const MinistriesCarousel({super.key});

  @override
  State<MinistriesCarousel> createState() => _MinistriesCarouselState();
}

class _MinistriesCarouselState extends State<MinistriesCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final content = context.watch<ContentProvider>();
    final ministries = content.ministries;

    if (_current >= ministries.length) {
      _current = 0;
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: ministries.length,
          options: CarouselOptions(
            height: 180,
            viewportFraction: 0.88,
            enlargeCenterPage: true,
            autoPlay: ministries.length > 1,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, _) => setState(() => _current = index),
          ),
          itemBuilder: (context, index, _) {
            return _MinistrySlide(
              category: ministries[index],
              isKannada: settings.isKannada,
              viewLabel: settings.t('viewEvents'),
              onTap: () => context.read<TabNavigation>().goToEvents(),
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(ministries.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _current == i ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _current == i
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _MinistrySlide extends StatelessWidget {
  final MinistryCategory category;
  final bool isKannada;
  final String viewLabel;
  final VoidCallback onTap;

  const _MinistrySlide({
    required this.category,
    required this.isKannada,
    required this.viewLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ContentImage(
              src: category.imageFor(isKannada),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.primary,
                alignment: Alignment.center,
                child: const Icon(Icons.image, color: Colors.white, size: 48),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      viewLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
