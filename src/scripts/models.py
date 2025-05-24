from pydantic import BaseModel
from typing import Optional


# ---------- Content ----------
class ContentBase(BaseModel):
    uploader_id: int
    title: str
    category: Optional[str] = None
    url: str


class ContentCreate(ContentBase):
    pass


class ContentUpdate(BaseModel):
    uploader_id: Optional[int] = None
    title: Optional[str] = None
    category: Optional[str] = None
    url: Optional[str] = None


class ContentInDB(ContentBase):
    id: int

    class Config:
        from_attributes = True


# ---------- Queue ----------
class QueueBase(BaseModel):
    reviewer_id: Optional[int] = None
    status: Optional[str] = None
    content_id: int


class QueueCreate(QueueBase):
    pass


class QueueUpdate(BaseModel):
    reviewer_id: Optional[int] = None
    status: Optional[str] = None


class QueueInDB(QueueBase):
    id: int

    class Config:
        from_attributes = True
