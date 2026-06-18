from pydantic import BaseModel, Field


class DailyDevotionPayload(BaseModel):
    titleEn: str = ""
    titleKn: str = ""
    seriesEn: str = ""
    seriesKn: str = ""
    speaker: str = ""
    date: str = ""
    verseReferenceEn: str = ""
    verseReferenceKn: str = ""
    verseTextEn: str = ""
    verseTextKn: str = ""
    reflectionEn: str = ""
    reflectionKn: str = ""
    published: bool = True


class MinistryTimingPayload(BaseModel):
    dayEn: str = ""
    dayKn: str = ""
    timeEn: str = ""
    timeKn: str = ""
    locationEn: str = ""
    locationKn: str = ""


class UpcomingEventPayload(BaseModel):
    imageUrl: str = ""
    title: str = ""
    subtitle: str = ""
    date: str = ""
    isKannada: bool = False
    sortOrder: int = 0
    published: bool = True


class MinistryPayload(BaseModel):
    id: str = ""
    englishImageUrl: str = ""
    kannadaImageUrl: str = ""
    timings: list[MinistryTimingPayload] = Field(default_factory=list)
    sortOrder: int = 0
    published: bool = True


class SermonPayload(BaseModel):
    title: str = ""
    summary: str = ""
    speaker: str = ""
    date: str = ""
    docxUrl: str = ""
    fileName: str = ""
    bodyText: str = ""
    sortOrder: int = 0
    published: bool = True


class AppConfigPayload(BaseModel):
    prayerTeamEmail: str = "prayer@mysorehopecenter.org"


class ReorderItem(BaseModel):
    id: str
    sortOrder: int


class ReorderPayload(BaseModel):
    items: list[ReorderItem]


class UploadImageResponse(BaseModel):
    url: str
    path: str


class UploadSermonResponse(BaseModel):
    docxUrl: str
    fileName: str
    bodyText: str

