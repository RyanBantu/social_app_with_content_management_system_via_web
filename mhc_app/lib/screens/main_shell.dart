import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings.dart';
import '../providers/tab_navigation.dart';
import '../theme/app_colors.dart';
import '../widgets/app_top_bar.dart';
import 'events_screen.dart';
import 'home_screen.dart';
import 'prayer_request_screen.dart';
import 'resources_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final nav = context.watch<TabNavigation>();
    final isDark = settings.isDark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(),
            Expanded(
              child: switch (nav.index) {
                0 => const HomeScreen(),
                1 => const ResourcesScreen(),
                2 => const PrayerRequestScreen(),
                3 => const EventsScreen(),
                _ => const HomeScreen(),
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: nav.index,
        onDestinationSelected: (i) {
          FocusManager.instance.primaryFocus?.unfocus();
          context.read<TabNavigation>().selectTab(i);
        },
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppColors.primary),
            label: settings.t('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book, color: AppColors.primary),
            label: settings.t('resources'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite, color: AppColors.primary),
            label: settings.t('prayer'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_outlined),
            selectedIcon: const Icon(Icons.event, color: AppColors.primary),
            label: settings.t('events'),
          ),
        ],
      ),
    );
  }
}
