import '../models/models.dart';

class AppData {
  static const upcomingEvents = [
    UpcomingEvent(
      imageUrl: 'assets/images/events/17.jpg',
      title: 'Revival Service',
      subtitle: 'Rev. Melwyn Jonathan — Chosen Generation International Worship Center',
      date: 'Friday, June 26 · 10 AM @ MHC',
      isKannada: false,
    ),
    UpcomingEvent(
      imageUrl: 'assets/images/events/18.jpg',
      title: 'ಉಜ್ಜೀವನ ಕೂಟ',
      subtitle: 'ಪಾಸ್ಟರ್. ಮೆಲ್ವಿನ್ ಜೊನಾಥನ್',
      date: 'ಶುಕ್ರವಾರ, ಜೂನ್ 26 · ಬೆಳಿಗ್ಗೆ 10:00',
      isKannada: true,
    ),
    UpcomingEvent(
      imageUrl: 'assets/images/events/19.jpg',
      title: 'Donut Worry!',
      subtitle: 'Hope Kidz & Grow Deeper — Love God + Love Others',
      date: 'June 26, 2026 · 9:30 AM – 4:30 PM',
      isKannada: false,
    ),
  ];

  static List<UpcomingEvent> carouselEventsFor(bool isKannada) {
    if (isKannada) {
      return [upcomingEvents[1], upcomingEvents[2]];
    }
    return [upcomingEvents[0], upcomingEvents[2]];
  }

  static const dailyDevotion = DailyDevotion(
    titleEn: 'The Great Exchange',
    titleKn: 'ಮಹಾನ್ ವಿನಿಮಯ',
    seriesEn: 'Robed in Righteousness',
    seriesKn: 'ನೀತಿಯಲ್ಲಿ ವಸ್ತ್ರಧಾರಿ',
    speaker: 'Paul Emmanuel',
    date: 'June 18, 2026',
    verseReferenceEn: '2 Corinthians 5:21',
    verseReferenceKn: '೨ ಕೊರಿಂಥಿಯರ ೫:೨೧',
    verseTextEn:
        'God made him who had no sin to be sin for us, so that in him we might become the righteousness of God.',
    verseTextKn:
        'ಪಾಪವಿಲ್ಲದವನನ್ನು ನಮಗಾಗಿ ಪಾಪವಾಗ ಮಾಡಿ, ನಾವು ದೇವರ ನೀತಿಯನ್ನು ಆತನಲ್ಲಿ ಪಡೆಯುವಂತೆ ಮಾಡಿದನು.',
    reflectionEn:
        'Christ took our sin upon Himself and gave us His righteousness in return. '
        'Today, rest in this exchange — you are not striving to earn God\'s favor. '
        'You are robed in the righteousness of Jesus. Walk in that truth with confidence and gratitude.',
    reflectionKn:
        'ಕ್ರಿಸ್ತನು ನಮ್ಮ ಪಾಪವನ್ನು ತೆಗೆದುಕೊಂಡು ತನ್ನ ನೀತಿಯನ್ನು ನಮಗೆ ನೀಡಿದನು. '
        'ಇಂದು ಈ ವಿನಿಮಯದಲ್ಲಿ ವಿಶ್ರಾಂತಿ ಪಡೆಯಿರಿ — ದೇವರ ಕೃಪೆಯನ್ನು ಸಂಪಾದಿಸಲು ನೀವು ಯತ್ನಿಸುತ್ತಿಲ್ಲ. '
        'ನೀವು ಯೇಸುವಿನ ನೀತಿಯಲ್ಲಿ ವಸ್ತ್ರಧಾರಿಯಾಗಿದ್ದೀರಿ. ಆ ಸತ್ಯದಲ್ಲಿ ನಂಬಿಕೆಯಿಂದ ನಡೆಯಿರಿ.',
  );

  static final sermonNotes = [
    SermonNote(
      date: DateTime(2025, 12, 31),
      title: "2025 New Year's Eve Sermon",
      speaker: 'Pastor',
      summary:
          'A message of hope and renewal as we step into a new year with Christ at the center of our lives.',
      docxUrl: 'assets/sermons/new_years_eve_2025.docx',
      fileName: 'new_years_eve_2025.docx',
    ),
    SermonNote(
      date: DateTime(2026, 1, 12),
      title: 'What Does a Disciple of Christ Look Like?',
      speaker: 'Pastor',
      summary:
          'Exploring the marks of a true disciple — humility, obedience, love, and a heart for the lost.',
      docxUrl: 'assets/sermons/disciple_looks_like.docx',
      fileName: 'disciple_looks_like.docx',
    ),
    SermonNote(
      date: DateTime(2026, 1, 19),
      title: 'The Life of Christ\'s Disciple',
      speaker: 'Pastor',
      summary:
          'Living daily in the footsteps of Jesus — carrying our cross and following Him wholeheartedly.',
      docxUrl: 'assets/sermons/life_of_disciple.docx',
      fileName: 'life_of_disciple.docx',
    ),
    SermonNote(
      date: DateTime(2026, 2, 2),
      title: 'The Disciples and the Holy Spirit',
      speaker: 'Pastor',
      summary:
          'How the Holy Spirit empowers disciples to live supernaturally and bear lasting fruit.',
      docxUrl: 'assets/sermons/disciples_holy_spirit.docx',
      fileName: 'disciples_holy_spirit.docx',
    ),
    SermonNote(
      date: DateTime(2026, 2, 9),
      title: 'Seeking Things Above',
      speaker: 'Pastor',
      summary:
          'What a disciple focuses on — setting our minds on heavenly things rather than earthly concerns.',
      docxUrl: 'assets/sermons/seeking_things_above.docx',
      fileName: 'seeking_things_above.docx',
    ),
    SermonNote(
      date: DateTime(2026, 2, 16),
      title: 'How Disciples Treat Each Other',
      speaker: 'Pastor',
      summary:
          'The love, forgiveness, and unity that should characterize relationships within the body of Christ.',
      docxUrl: 'assets/sermons/disciples_treat_each_other.docx',
      fileName: 'disciples_treat_each_other.docx',
    ),
    SermonNote(
      date: DateTime(2026, 2, 23),
      title: 'Disciples Are Fruitful',
      speaker: 'Pastor',
      summary:
          'Bearing fruit that remains — abiding in Christ and producing evidence of transformed lives.',
      docxUrl: 'assets/sermons/disciples_fruitful.docx',
      fileName: 'disciples_fruitful.docx',
    ),
  ];

  static const ministryCategories = [
    MinistryCategory(
      id: 'esther_prayer',
      englishImageUrl: 'assets/images/ministries/1.jpg',
      kannadaImageUrl: 'assets/images/ministries/2.jpg',
      timings: [
        MinistryTiming(
          dayEn: 'Every Tuesday',
          dayKn: 'ಪ್ರತಿ ಮಂಗಳವಾರ',
          timeEn: '10:00 AM – 12:00 PM',
          timeKn: 'ಬೆಳಿಗ್ಗೆ 10 – ಮಧ್ಯಾಹ್ನ 12',
          locationEn: 'Mysore Hope Center',
          locationKn: 'ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್',
        ),
      ],
    ),
    MinistryCategory(
      id: 'midweek_fellowship',
      englishImageUrl: 'assets/images/ministries/3.jpg',
      kannadaImageUrl: 'assets/images/ministries/4.jpg',
      timings: [
        MinistryTiming(
          dayEn: 'Every Wednesday',
          dayKn: 'ಪ್ರತಿ ಬುಧವಾರ',
          timeEn: '6:00 PM',
          timeKn: 'ಸಂಜೆ 6 ಗಂಟೆ',
          locationEn: 'Mysore Hope Center',
          locationKn: 'ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್',
        ),
      ],
    ),
    MinistryCategory(
      id: 'young_adults',
      englishImageUrl: 'assets/images/ministries/5.jpg',
      kannadaImageUrl: 'assets/images/ministries/6.jpg',
      timings: [
        MinistryTiming(
          dayEn: 'Every Thursday',
          dayKn: 'ಪ್ರತಿ ಗುರುವಾರ',
          timeEn: '6:30 PM',
          timeKn: 'ಸಂಜೆ 6:30',
          locationEn: 'Hope Café',
          locationKn: 'ಹೋಪ್ ಕ್ಯಾಫೆ',
        ),
      ],
    ),
    MinistryCategory(
      id: 'fasting_prayer',
      englishImageUrl: 'assets/images/ministries/7.jpg',
      kannadaImageUrl: 'assets/images/ministries/8.jpg',
      timings: [
        MinistryTiming(
          dayEn: 'Every Friday',
          dayKn: 'ಪ್ರತಿ ಶುಕ್ರವಾರ',
          timeEn: '10:00 AM – 12:15 PM',
          timeKn: 'ಬೆಳಿಗ್ಗೆ 10 – ಮಧ್ಯಾಹ್ನ 12:15',
          locationEn: 'Mysore Hope Center',
          locationKn: 'ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್',
        ),
      ],
    ),
    MinistryCategory(
      id: 'water_baptism',
      englishImageUrl: 'assets/images/ministries/9.jpg',
      kannadaImageUrl: 'assets/images/ministries/10.jpg',
      timings: [
        MinistryTiming(
          dayEn: 'Every Second Saturday',
          dayKn: 'ಪ್ರತಿ ಎರಡನೇ ಶನಿವಾರ',
          timeEn: 'Morning',
          timeKn: 'ಬೆಳಿಗ್ಗೆ',
          locationEn: 'Mysore Hope Center',
          locationKn: 'ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್',
        ),
      ],
    ),
    MinistryCategory(
      id: 'womens_fellowship',
      englishImageUrl: 'assets/images/ministries/11.jpg',
      kannadaImageUrl: 'assets/images/ministries/12.jpg',
      timings: [
        MinistryTiming(
          dayEn: 'Every Second Saturday',
          dayKn: 'ಪ್ರತಿ ಎರಡನೇ ಶನಿವಾರ',
          timeEn: '3:00 PM – 4:00 PM',
          timeKn: 'ಮಧ್ಯಾಹ್ನ 3 – 4',
          locationEn: 'Hope Café',
          locationKn: 'ಹೋಪ್ ಕ್ಯಾಫೆ',
        ),
      ],
    ),
    MinistryCategory(
      id: 'mens_fellowship',
      englishImageUrl: 'assets/images/ministries/13.jpg',
      kannadaImageUrl: 'assets/images/ministries/14.jpg',
      timings: [
        MinistryTiming(
          dayEn: 'Every Second Saturday',
          dayKn: 'ಪ್ರತಿ ಎರಡನೇ ಶನಿವಾರ',
          timeEn: '7:00 AM – 8:00 AM',
          timeKn: 'ಬೆಳಿಗ್ಗೆ 7 – 8',
          locationEn: 'Mysore Hope Center',
          locationKn: 'ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್',
        ),
      ],
    ),
    MinistryCategory(
      id: 'fruit_distribution',
      englishImageUrl: 'assets/images/ministries/15.jpg',
      kannadaImageUrl: 'assets/images/ministries/15.jpg',
      timings: [
        MinistryTiming(
          dayEn: 'Every 1st & 3rd Wednesday',
          dayKn: 'ಪ್ರತಿ ಮೊದಲ ಮತ್ತು ಮೂರನೇ ಬುಧವಾರ',
          timeEn: '10:30 AM',
          timeKn: 'ಬೆಳಿಗ್ಗೆ 10:30',
          locationEn: 'Mysore Hope Center',
          locationKn: 'ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್',
        ),
      ],
    ),
  ];

  static const prayerTeamEmail = 'prayer@mysorehopecenter.org';
}
