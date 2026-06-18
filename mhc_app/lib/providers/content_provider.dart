import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../data/app_data.dart';
import '../firebase_options.dart';
import '../models/models.dart';
import '../repositories/content_repository.dart';

class ContentProvider extends ChangeNotifier {
  ContentProvider({ContentRepository? repository})
      : _repository = repository ?? ContentRepository();

  final ContentRepository _repository;
  final List<StreamSubscription<dynamic>> _subs = [];

  bool firebaseEnabled = false;
  DailyDevotion devotion = AppData.dailyDevotion;
  List<UpcomingEvent> events = List.from(AppData.upcomingEvents);
  List<MinistryCategory> ministries = List.from(AppData.ministryCategories);
  List<SermonNote> sermons = List.from(AppData.sermonNotes);
  String prayerTeamEmail = AppData.prayerTeamEmail;

  Future<void> init() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      firebaseEnabled = true;
      _listen();
    } catch (e) {
      debugPrint('Firebase unavailable, using bundled content: $e');
      firebaseEnabled = false;
    }
    notifyListeners();
  }

  void _listen() {
    _subs.add(_repository.watchDevotion().listen((d) {
      devotion = d;
      notifyListeners();
    }));
    _subs.add(_repository.watchEvents().listen((list) {
      events = list;
      notifyListeners();
    }));
    _subs.add(_repository.watchMinistries().listen((list) {
      ministries = list;
      notifyListeners();
    }));
    _subs.add(_repository.watchSermons().listen((list) {
      sermons = list;
      notifyListeners();
    }));
    _subs.add(_repository.watchPrayerEmail().listen((email) {
      prayerTeamEmail = email;
      notifyListeners();
    }));
  }

  List<UpcomingEvent> carouselEventsFor(bool isKannada) {
    if (events.isEmpty) return AppData.carouselEventsFor(isKannada);
    if (isKannada) {
      final kn = events.where((e) => e.isKannada).toList();
      final rest = events.where((e) => !e.isKannada).toList();
      if (kn.isEmpty) return events;
      return [...kn, ...rest];
    }
    final en = events.where((e) => !e.isKannada).toList();
    final rest = events.where((e) => e.isKannada).toList();
    if (en.isEmpty) return events;
    return [...en, ...rest];
  }

  @override
  void dispose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    super.dispose();
  }
}
