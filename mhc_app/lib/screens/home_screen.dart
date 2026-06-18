import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings.dart';
import '../widgets/devotion_card.dart';
import '../widgets/event_carousel.dart';
import '../widgets/ministries_carousel.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SectionTitle(title: settings.t('dailyDevotion')),
        ),
        const SliverToBoxAdapter(child: DevotionCard()),
        SliverToBoxAdapter(
          child: SectionTitle(title: settings.t('upcomingEvents')),
        ),
        const SliverToBoxAdapter(child: EventCarousel()),
        SliverToBoxAdapter(
          child: SectionTitle(title: settings.t('ministries')),
        ),
        const SliverToBoxAdapter(child: MinistriesCarousel()),
        SliverToBoxAdapter(child: SizedBox(height: 24 + bottomPad)),
      ],
    );
  }
}
