"""Shared Firestore paths for MHC CMS.

Logical schema (under ``content/``):
  dailyDevotion/current   → devotion doc
  upcomingEvents/{id}     → event docs
  ministries/{id}         → ministry docs
  sermons/{id}            → sermon docs
"""

from google.cloud.firestore_v1 import Client


def devotion_ref(db: Client):
    return (
        db.collection("content")
        .document("dailyDevotion")
        .collection("current")
        .document("current")
    )


def events_col(db: Client):
    return db.collection("content").document("upcomingEvents").collection("events")


def ministries_col(db: Client):
    return db.collection("content").document("ministries").collection("entries")


def sermons_col(db: Client):
    return db.collection("content").document("sermons").collection("entries")
