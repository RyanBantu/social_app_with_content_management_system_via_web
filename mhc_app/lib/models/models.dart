class UpcomingEvent {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String date;
  final bool isKannada;
  final int sortOrder;
  final bool published;

  const UpcomingEvent({
    this.id = '',
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.date,
    this.isKannada = false,
    this.sortOrder = 0,
    this.published = true,
  });

  /// Legacy bundled asset path or remote URL.
  String get image => imageUrl;

  factory UpcomingEvent.fromJson(Map<String, dynamic> json, {String? id}) {
    return UpcomingEvent(
      id: id ?? json['id'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      date: json['date'] as String? ?? '',
      isKannada: json['isKannada'] as bool? ?? false,
      sortOrder: json['sortOrder'] as int? ?? 0,
      published: json['published'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'title': title,
        'subtitle': subtitle,
        'date': date,
        'isKannada': isKannada,
        'sortOrder': sortOrder,
        'published': published,
      };
}

class DailyDevotion {
  final String titleEn;
  final String titleKn;
  final String seriesEn;
  final String seriesKn;
  final String speaker;
  final String date;
  final String verseReferenceEn;
  final String verseReferenceKn;
  final String verseTextEn;
  final String verseTextKn;
  final String reflectionEn;
  final String reflectionKn;
  final bool published;

  const DailyDevotion({
    required this.titleEn,
    required this.titleKn,
    required this.seriesEn,
    required this.seriesKn,
    required this.speaker,
    required this.date,
    required this.verseReferenceEn,
    required this.verseReferenceKn,
    required this.verseTextEn,
    required this.verseTextKn,
    required this.reflectionEn,
    required this.reflectionKn,
    this.published = true,
  });

  String title(bool isKannada) => isKannada ? titleKn : titleEn;
  String series(bool isKannada) => isKannada ? seriesKn : seriesEn;
  String verseReference(bool isKannada) =>
      isKannada ? verseReferenceKn : verseReferenceEn;
  String verseText(bool isKannada) => isKannada ? verseTextKn : verseTextEn;
  String reflection(bool isKannada) =>
      isKannada ? reflectionKn : reflectionEn;

  factory DailyDevotion.fromJson(Map<String, dynamic> json) {
    return DailyDevotion(
      titleEn: json['titleEn'] as String? ?? '',
      titleKn: json['titleKn'] as String? ?? '',
      seriesEn: json['seriesEn'] as String? ?? '',
      seriesKn: json['seriesKn'] as String? ?? '',
      speaker: json['speaker'] as String? ?? '',
      date: json['date'] as String? ?? '',
      verseReferenceEn: json['verseReferenceEn'] as String? ?? '',
      verseReferenceKn: json['verseReferenceKn'] as String? ?? '',
      verseTextEn: json['verseTextEn'] as String? ?? '',
      verseTextKn: json['verseTextKn'] as String? ?? '',
      reflectionEn: json['reflectionEn'] as String? ?? '',
      reflectionKn: json['reflectionKn'] as String? ?? '',
      published: json['published'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'titleEn': titleEn,
        'titleKn': titleKn,
        'seriesEn': seriesEn,
        'seriesKn': seriesKn,
        'speaker': speaker,
        'date': date,
        'verseReferenceEn': verseReferenceEn,
        'verseReferenceKn': verseReferenceKn,
        'verseTextEn': verseTextEn,
        'verseTextKn': verseTextKn,
        'reflectionEn': reflectionEn,
        'reflectionKn': reflectionKn,
        'published': published,
      };
}

class SermonNote {
  final String id;
  final DateTime date;
  final String title;
  final String summary;
  final String speaker;
  final String docxUrl;
  final String fileName;
  final String bodyText;
  final int sortOrder;
  final bool published;

  const SermonNote({
    this.id = '',
    required this.date,
    required this.title,
    required this.summary,
    required this.speaker,
    this.docxUrl = '',
    this.fileName = '',
    this.bodyText = '',
    this.sortOrder = 0,
    this.published = true,
  });

  /// Legacy bundled asset path or remote URL.
  String get docxAsset => docxUrl.isNotEmpty ? docxUrl : fileName;

  factory SermonNote.fromJson(Map<String, dynamic> json, {String? id}) {
    final dateRaw = json['date'];
    DateTime parsedDate;
    if (dateRaw is String) {
      parsedDate = DateTime.tryParse(dateRaw) ?? DateTime.now();
    } else if (dateRaw != null && dateRaw.toString().contains('Timestamp')) {
      parsedDate = DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return SermonNote(
      id: id ?? json['id'] as String? ?? '',
      date: parsedDate,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      speaker: json['speaker'] as String? ?? '',
      docxUrl: json['docxUrl'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      bodyText: json['bodyText'] as String? ?? '',
      sortOrder: json['sortOrder'] as int? ?? 0,
      published: json['published'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'title': title,
        'summary': summary,
        'speaker': speaker,
        'docxUrl': docxUrl,
        'fileName': fileName,
        'bodyText': bodyText,
        'sortOrder': sortOrder,
        'published': published,
      };
}

class MinistryCategory {
  final String id;
  final String englishImageUrl;
  final String kannadaImageUrl;
  final List<MinistryTiming> timings;
  final int sortOrder;
  final bool published;

  const MinistryCategory({
    required this.id,
    required this.englishImageUrl,
    required this.kannadaImageUrl,
    required this.timings,
    this.sortOrder = 0,
    this.published = true,
  });

  String get englishImage => englishImageUrl;
  String get kannadaImage => kannadaImageUrl;

  String imageFor(bool isKannada) =>
      isKannada ? kannadaImageUrl : englishImageUrl;

  factory MinistryCategory.fromJson(Map<String, dynamic> json, {String? id}) {
    final timingsRaw = json['timings'] as List<dynamic>? ?? [];
    return MinistryCategory(
      id: id ?? json['id'] as String? ?? '',
      englishImageUrl: json['englishImageUrl'] as String? ?? '',
      kannadaImageUrl: json['kannadaImageUrl'] as String? ?? '',
      timings: timingsRaw
          .map((t) => MinistryTiming.fromJson(t as Map<String, dynamic>))
          .toList(),
      sortOrder: json['sortOrder'] as int? ?? 0,
      published: json['published'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'englishImageUrl': englishImageUrl,
        'kannadaImageUrl': kannadaImageUrl,
        'timings': timings.map((t) => t.toJson()).toList(),
        'sortOrder': sortOrder,
        'published': published,
      };
}

class MinistryTiming {
  final String dayEn;
  final String dayKn;
  final String timeEn;
  final String timeKn;
  final String locationEn;
  final String locationKn;

  const MinistryTiming({
    required this.dayEn,
    required this.dayKn,
    required this.timeEn,
    required this.timeKn,
    required this.locationEn,
    required this.locationKn,
  });

  String dayFor(bool isKannada) => isKannada ? dayKn : dayEn;
  String timeFor(bool isKannada) => isKannada ? timeKn : timeEn;
  String locationFor(bool isKannada) => isKannada ? locationKn : locationEn;

  factory MinistryTiming.fromJson(Map<String, dynamic> json) {
    return MinistryTiming(
      dayEn: json['dayEn'] as String? ?? '',
      dayKn: json['dayKn'] as String? ?? '',
      timeEn: json['timeEn'] as String? ?? '',
      timeKn: json['timeKn'] as String? ?? '',
      locationEn: json['locationEn'] as String? ?? '',
      locationKn: json['locationKn'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'dayEn': dayEn,
        'dayKn': dayKn,
        'timeEn': timeEn,
        'timeKn': timeKn,
        'locationEn': locationEn,
        'locationKn': locationKn,
      };
}

class AppConfig {
  final String prayerTeamEmail;

  const AppConfig({required this.prayerTeamEmail});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      prayerTeamEmail:
          json['prayerTeamEmail'] as String? ?? 'prayer@mysorehopecenter.org',
    );
  }
}
