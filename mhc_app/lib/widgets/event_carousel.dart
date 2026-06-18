import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../models/models.dart';
import '../providers/app_settings.dart';
import '../theme/app_colors.dart';
import '../widgets/content_image.dart';

class EventCarousel extends StatefulWidget {
  const EventCarousel({super.key});

  @override
  State<EventCarousel> createState() => _EventCarouselState();
}

class _EventCarouselState extends State<EventCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final content = context.watch<ContentProvider>();
    final events = content.carouselEventsFor(settings.isKannada);

    if (_current >= events.length) {
      _current = 0;
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: events.length,
          options: CarouselOptions(
            height: 220,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: events.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, _) => setState(() => _current = index),
          ),
          itemBuilder: (context, index, _) {
            return _EventCard(event: events[index]);
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(events.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _current == i ? 24 : 8,
              height: 8,
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

class _EventCard extends StatelessWidget {
  final UpcomingEvent event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${event.title}. ${event.date}. ${event.subtitle}',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black,
        ),
        child: ContentImage(
          src: event.image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          semanticLabel: event.title,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.primary,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Text(
              event.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
