import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/app_data.dart';
import '../models/models.dart';

/// Firestore paths mirror backend ``firestore_paths.py``.
class ContentRepository {
  ContentRepository({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  static bool get isRemoteUrl => Firebase.apps.isNotEmpty;

  DocumentReference<Map<String, dynamic>> get _devotionRef => _db
      .collection('content')
      .doc('dailyDevotion')
      .collection('current')
      .doc('current');

  CollectionReference<Map<String, dynamic>> get _eventsCol => _db
      .collection('content')
      .doc('upcomingEvents')
      .collection('events');

  CollectionReference<Map<String, dynamic>> get _ministriesCol => _db
      .collection('content')
      .doc('ministries')
      .collection('entries');

  CollectionReference<Map<String, dynamic>> get _sermonsCol => _db
      .collection('content')
      .doc('sermons')
      .collection('entries');

  DocumentReference<Map<String, dynamic>> get _configRef =>
      _db.collection('config').doc('app');

  Stream<DailyDevotion> watchDevotion() {
    return _devotionRef.snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) {
        return AppData.dailyDevotion;
      }
      return DailyDevotion.fromJson(snap.data()!);
    });
  }

  Stream<List<UpcomingEvent>> watchEvents() {
    return _eventsCol.orderBy('sortOrder').snapshots().map((snap) {
      if (snap.docs.isEmpty) return AppData.upcomingEvents;
      return snap.docs
          .map((d) => UpcomingEvent.fromJson(d.data(), id: d.id))
          .where((e) => e.published)
          .toList();
    });
  }

  Stream<List<MinistryCategory>> watchMinistries() {
    return _ministriesCol.orderBy('sortOrder').snapshots().map((snap) {
      if (snap.docs.isEmpty) return AppData.ministryCategories;
      return snap.docs
          .map((d) => MinistryCategory.fromJson(d.data(), id: d.id))
          .where((m) => m.published)
          .toList();
    });
  }

  Stream<List<SermonNote>> watchSermons() {
    return _sermonsCol.orderBy('sortOrder').snapshots().map((snap) {
      if (snap.docs.isEmpty) return AppData.sermonNotes;
      return snap.docs
          .map((d) => SermonNote.fromJson(d.data(), id: d.id))
          .where((s) => s.published)
          .toList();
    });
  }

  Stream<String> watchPrayerEmail() {
    return _configRef.snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) {
        return AppData.prayerTeamEmail;
      }
      return AppConfig.fromJson(snap.data()!).prayerTeamEmail;
    });
  }
}
