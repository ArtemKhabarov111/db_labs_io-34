from fastapi import FastAPI, HTTPException
from typing import List
from config import get_connection
from models import (
    ContentInDB, ContentCreate, ContentUpdate,
    QueueInDB, QueueCreate, QueueUpdate
)

app = FastAPI(title="Lab4 RESTful API")


# ======== HELPER FUNCTIONS ==========

def fetch_all(table: str):
    with get_connection() as conn:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(f"SELECT * FROM {table}")
        return cursor.fetchall()


def fetch_by_id(table: str, key: str, value: int):
    with get_connection() as conn:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(f"SELECT * FROM {table} WHERE {key} = %s", (value,))
        result = cursor.fetchone()
        if not result:
            raise HTTPException(status_code=404, detail=f"{table.capitalize()} not found")
        return result


def insert_data(query: str, values: tuple):
    with get_connection() as conn:
        cursor = conn.cursor()
        try:
            cursor.execute(query, values)
            conn.commit()
        except Exception as e:
            conn.rollback()
            raise HTTPException(status_code=500, detail=str(e))


def update_data(table: str, key: str, value: int, update_data: dict):
    if not update_data:
        raise HTTPException(status_code=400, detail="No data to update")
    fields = ', '.join(f"{k} = %s" for k in update_data)
    query = f"UPDATE {table} SET {fields} WHERE {key} = %s"
    with get_connection() as conn:
        cursor = conn.cursor()
        try:
            cursor.execute(query, list(update_data.values()) + [value])
            conn.commit()
        except Exception as e:
            conn.rollback()
            raise HTTPException(status_code=500, detail=str(e))


def delete_by_id(table: str, key: str, value: int):
    with get_connection() as conn:
        cursor = conn.cursor()
        try:
            cursor.execute(f"DELETE FROM {table} WHERE {key} = %s", (value,))
            conn.commit()
            if cursor.rowcount == 0:
                raise HTTPException(status_code=404, detail=f"{table.capitalize()} not found")
        except Exception as e:
            conn.rollback()
            raise HTTPException(status_code=500, detail=str(e))


# ========== CONTENT ENDPOINTS ===========
@app.get("/content", response_model=List[ContentInDB], tags=["Content"])
async def get_all_content():
    return fetch_all("Content")


@app.get("/content/{content_id}", response_model=ContentInDB, tags=["Content"])
async def get_content(content_id: int):
    return fetch_by_id("Content", "id", content_id)


@app.post("/content", response_model=dict, status_code=201, tags=["Content"])
async def create_content(content: ContentCreate):
    insert_data(
        "INSERT INTO Content (uploader_id, title, category, url) VALUES (%s, %s, %s, %s)",
        (content.uploader_id, content.title, content.category, content.url)
    )
    return {"message": "Content added"}


@app.put("/content/{content_id}", response_model=ContentInDB, tags=["Content"])
async def update_content(content_id: int, content_update: ContentUpdate):
    update_data("Content", "id", content_id, content_update.model_dump(exclude_unset=True))
    return await get_content(content_id)


@app.delete("/content/{content_id}", response_model=dict, tags=["Content"])
async def delete_content(content_id: int):
    delete_by_id("Content", "id", content_id)
    return {"message": f"Content with id {content_id} deleted"}


# ========== QUEUE ENDPOINTS ===========
@app.get("/queue", response_model=List[QueueInDB], tags=["Queue"])
async def get_all_queue():
    return fetch_all("Queue")


@app.get("/queue/{queue_id}", response_model=QueueInDB, tags=["Queue"])
async def get_queue(queue_id: int):
    return fetch_by_id("Queue", "id", queue_id)


@app.post("/queue", response_model=dict, status_code=201, tags=["Queue"])
async def create_queue(item: QueueCreate):
    insert_data(
        "INSERT INTO Queue (reviewer_id, status, Content_id) VALUES (%s, %s, %s)",
        (item.reviewer_id, item.status, item.content_id)
    )
    return {"message": "Queue item added"}


@app.put("/queue/{queue_id}", response_model=QueueInDB, tags=["Queue"])
async def update_queue(queue_id: int, queue_update: QueueUpdate):
    update_data("Queue", "id", queue_id, queue_update.model_dump(exclude_unset=True))
    return await get_queue(queue_id)


@app.delete("/queue/{queue_id}", response_model=dict, tags=["Queue"])
async def delete_queue(queue_id: int):
    delete_by_id("Queue", "id", queue_id)
    return {"message": f"Queue item with id {queue_id} deleted"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)
