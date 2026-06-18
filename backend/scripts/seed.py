#!/usr/bin/env python3
"""Upload bundled Flutter assets to Firebase Storage and seed Firestore."""

from __future__ import annotations

import sys
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
ASSETS = REPO / "mhc_app" / "assets"

sys.path.insert(0, str(ROOT))

from app.firebase import get_bucket, get_db, init_firebase  # noqa: E402
from app.firestore_paths import (  # noqa: E402
    devotion_ref,
    events_col,
    ministries_col,
    sermons_col,
)
from app.services.docx_extract import upload_docx  # noqa: E402
from app.services.image import resize_and_upload_image  # noqa: E402
from google.cloud.firestore_v1 import SERVER_TIMESTAMP  # noqa: E402


def upload_local_image(path: Path, folder: str) -> str:
    data = path.read_bytes()
    url, _ = resize_and_upload_image(data, folder)
    return url


def seed_devotion(db):
    devotion_ref(db).set({
        "titleEn": "The Great Exchange",
        "titleKn": "ಮಹಾನ್ ವಿನಿಮಯ",
        "seriesEn": "Robed in Righteousness",
        "seriesKn": "ನೀತಿಯಲ್ಲಿ ವಸ್ತ್ರಧಾರಿ",
        "speaker": "Paul Emmanuel",
        "date": "June 18, 2026",
        "verseReferenceEn": "2 Corinthians 5:21",
        "verseReferenceKn": "೨ ಕೊರಿಂಥಿಯರ ೫:೨೧",
        "verseTextEn": (
            "God made him who had no sin to be sin for us, so that in him "
            "we might become the righteousness of God."
        ),
        "verseTextKn": (
            "ಪಾಪವಿಲ್ಲದವನನ್ನು ನಮಗಾಗಿ ಪಾಪವಾಗ ಮಾಡಿ, ನಾವು ದೇವರ ನೀತಿಯನ್ನು "
            "ಆತನಲ್ಲಿ ಪಡೆಯುವಂತೆ ಮಾಡಿದನು."
        ),
        "reflectionEn": (
            "Christ took our sin upon Himself and gave us His righteousness in return. "
            "Today, rest in this exchange — you are not striving to earn God's favor. "
            "You are robed in the righteousness of Jesus. Walk in that truth with "
            "confidence and gratitude."
        ),
        "reflectionKn": (
            "ಕ್ರಿಸ್ತನು ನಮ್ಮ ಪಾಪವನ್ನು ತೆಗೆದುಕೊಂಡು ತನ್ನ ನೀತಿಯನ್ನು ನಮಗೆ ನೀಡಿದನು. "
            "ಇಂದು ಈ ವಿನಿಮಯದಲ್ಲಿ ವಿಶ್ರಾಂತಿ ಪಡೆಯಿರಿ — ದೇವರ ಕೃಪೆಯನ್ನು ಸಂಪಾದಿಸಲು "
            "ನೀವು ಯತ್ನಿಸುತ್ತಿಲ್ಲ. ನೀವು ಯೇಸುವಿನ ನೀತಿಯಲ್ಲಿ ವಸ್ತ್ರಧಾರಿಯಾಗಿದ್ದೀರಿ. "
            "ಆ ಸತ್ಯದಲ್ಲಿ ನಂಬಿಕೆಯಿಂದ ನಡೆಯಿರಿ."
        ),
        "published": True,
        "updatedAt": SERVER_TIMESTAMP,
    })
    print("Seeded daily devotion")


def seed_events(db):
    events = [
        (
            "17.jpg",
            "Revival Service",
            "Rev. Melwyn Jonathan — Chosen Generation International Worship Center",
            "Friday, June 26 · 10 AM @ MHC",
            False,
            0,
        ),
        (
            "18.jpg",
            "ಉಜ್ಜೀವನ ಕೂಟ",
            "ಪಾಸ್ಟರ್. ಮೆಲ್ವಿನ್ ಜೊನಾಥನ್",
            "ಶುಕ್ರವಾರ, ಜೂನ್ 26 · ಬೆಳಿಗ್ಗೆ 10:00",
            True,
            1,
        ),
        (
            "19.jpg",
            "Donut Worry!",
            "Hope Kidz & Grow Deeper — Love God + Love Others",
            "June 26, 2026 · 9:30 AM – 4:30 PM",
            False,
            2,
        ),
    ]
    col = events_col(db)
    for img, title, subtitle, date, is_kn, order in events:
        img_path = ASSETS / "images" / "events" / img
        url = upload_local_image(img_path, "events") if img_path.exists() else ""
        col.add({
            "imageUrl": url,
            "title": title,
            "subtitle": subtitle,
            "date": date,
            "isKannada": is_kn,
            "sortOrder": order,
            "published": True,
            "updatedAt": SERVER_TIMESTAMP,
        })
    print("Seeded events")


MINISTRIES = [
    (
        "esther_prayer",
        "1.jpg",
        "2.jpg",
        [
            {
                "dayEn": "Every Tuesday",
                "dayKn": "ಪ್ರತಿ ಮಂಗಳವಾರ",
                "timeEn": "10:00 AM – 12:00 PM",
                "timeKn": "ಬೆಳಿಗ್ಗೆ 10 – ಮಧ್ಯಾಹ್ನ 12",
                "locationEn": "Mysore Hope Center",
                "locationKn": "ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್",
            }
        ],
    ),
    (
        "midweek_fellowship",
        "3.jpg",
        "4.jpg",
        [
            {
                "dayEn": "Every Wednesday",
                "dayKn": "ಪ್ರತಿ ಬುಧವಾರ",
                "timeEn": "6:00 PM",
                "timeKn": "ಸಂಜೆ 6 ಗಂಟೆ",
                "locationEn": "Mysore Hope Center",
                "locationKn": "ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್",
            }
        ],
    ),
    (
        "young_adults",
        "5.jpg",
        "6.jpg",
        [
            {
                "dayEn": "Every Thursday",
                "dayKn": "ಪ್ರತಿ ಗುರುವಾರ",
                "timeEn": "6:30 PM",
                "timeKn": "ಸಂಜೆ 6:30",
                "locationEn": "Hope Café",
                "locationKn": "ಹೋಪ್ ಕ್ಯಾಫೆ",
            }
        ],
    ),
    (
        "fasting_prayer",
        "7.jpg",
        "8.jpg",
        [
            {
                "dayEn": "Every Friday",
                "dayKn": "ಪ್ರತಿ ಶುಕ್ರವಾರ",
                "timeEn": "10:00 AM – 12:15 PM",
                "timeKn": "ಬೆಳಿಗ್ಗೆ 10 – ಮಧ್ಯಾಹ್ನ 12:15",
                "locationEn": "Mysore Hope Center",
                "locationKn": "ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್",
            }
        ],
    ),
    (
        "water_baptism",
        "9.jpg",
        "10.jpg",
        [
            {
                "dayEn": "Every Second Saturday",
                "dayKn": "ಪ್ರತಿ ಎರಡನೇ ಶನಿವಾರ",
                "timeEn": "Morning",
                "timeKn": "ಬೆಳಿಗ್ಗೆ",
                "locationEn": "Mysore Hope Center",
                "locationKn": "ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್",
            }
        ],
    ),
    (
        "womens_fellowship",
        "11.jpg",
        "12.jpg",
        [
            {
                "dayEn": "Every Second Saturday",
                "dayKn": "ಪ್ರತಿ ಎರಡನೇ ಶನಿವಾರ",
                "timeEn": "3:00 PM – 4:00 PM",
                "timeKn": "ಮಧ್ಯಾಹ್ನ 3 – 4",
                "locationEn": "Hope Café",
                "locationKn": "ಹೋಪ್ ಕ್ಯಾಫೆ",
            }
        ],
    ),
    (
        "mens_fellowship",
        "13.jpg",
        "14.jpg",
        [
            {
                "dayEn": "Every Second Saturday",
                "dayKn": "ಪ್ರತಿ ಎರಡನೇ ಶನಿವಾರ",
                "timeEn": "7:00 AM – 8:00 AM",
                "timeKn": "ಬೆಳಿಗ್ಗೆ 7 – 8",
                "locationEn": "Mysore Hope Center",
                "locationKn": "ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್",
            }
        ],
    ),
    (
        "fruit_distribution",
        "15.jpg",
        "15.jpg",
        [
            {
                "dayEn": "Every 1st & 3rd Wednesday",
                "dayKn": "ಪ್ರತಿ ಮೊದಲ ಮತ್ತು ಮೂರನೇ ಬುಧವಾರ",
                "timeEn": "10:30 AM",
                "timeKn": "ಬೆಳಿಗ್ಗೆ 10:30",
                "locationEn": "Mysore Hope Center",
                "locationKn": "ಮೈಸೂರು ಹೋಪ್ ಸೆಂಟರ್",
            }
        ],
    ),
]

SERMONS = [
    ("new_years_eve_2025.docx", datetime(2025, 12, 31), "2025 New Year's Eve Sermon",
     "A message of hope and renewal as we step into a new year with Christ at the center of our lives."),
    ("disciple_looks_like.docx", datetime(2026, 1, 12), "What Does a Disciple of Christ Look Like?",
     "Exploring the marks of a true disciple — humility, obedience, love, and a heart for the lost."),
    ("life_of_disciple.docx", datetime(2026, 1, 19), "The Life of Christ's Disciple",
     "Living daily in the footsteps of Jesus — carrying our cross and following Him wholeheartedly."),
    ("disciples_holy_spirit.docx", datetime(2026, 2, 2), "The Disciples and the Holy Spirit",
     "How the Holy Spirit empowers disciples to live supernaturally and bear lasting fruit."),
    ("seeking_things_above.docx", datetime(2026, 2, 9), "Seeking Things Above",
     "What a disciple focuses on — setting our minds on heavenly things rather than earthly concerns."),
    ("disciples_treat_each_other.docx", datetime(2026, 2, 16), "How Disciples Treat Each Other",
     "The love, forgiveness, and unity that should characterize relationships within the body of Christ."),
    ("disciples_fruitful.docx", datetime(2026, 2, 23), "Disciples Are Fruitful",
     "Bearing fruit that remains — abiding in Christ and producing evidence of transformed lives."),
]


def seed_ministries(db):
    col = ministries_col(db)
    for i, (mid, en, kn, timings) in enumerate(MINISTRIES):
        en_path = ASSETS / "images" / "ministries" / en
        kn_path = ASSETS / "images" / "ministries" / kn
        col.document(mid).set({
            "id": mid,
            "englishImageUrl": upload_local_image(en_path, "ministries") if en_path.exists() else "",
            "kannadaImageUrl": upload_local_image(kn_path, "ministries") if kn_path.exists() else "",
            "timings": timings,
            "sortOrder": i,
            "published": True,
            "updatedAt": SERVER_TIMESTAMP,
        })
    print("Seeded ministries")


def seed_sermons(db):
    col = sermons_col(db)
    for i, (filename, date, title, summary) in enumerate(SERMONS):
        docx_path = ASSETS / "sermons" / filename
        if not docx_path.exists():
            print(f"  Skipping missing sermon: {filename}")
            continue
        data = docx_path.read_bytes()
        url, fname, body = upload_docx(data, filename)
        col.add({
            "title": title,
            "summary": summary,
            "speaker": "Pastor",
            "date": date.isoformat() + "Z",
            "docxUrl": url,
            "fileName": fname,
            "bodyText": body,
            "sortOrder": i,
            "published": True,
            "updatedAt": SERVER_TIMESTAMP,
        })
    print("Seeded sermons")


def seed_config(db):
    db.collection("config").document("app").set({
        "prayerTeamEmail": "prayer@mysorehopecenter.org",
        "updatedAt": SERVER_TIMESTAMP,
    }, merge=True)
    print("Seeded config")


def main():
    init_firebase()
    db = get_db()
    get_bucket()
    seed_devotion(db)
    seed_events(db)
    seed_ministries(db)
    seed_sermons(db)
    seed_config(db)
    print("Done.")


if __name__ == "__main__":
    main()
