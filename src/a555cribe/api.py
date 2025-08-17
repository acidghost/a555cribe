import io
from typing import cast

from fastapi import FastAPI, File, HTTPException, UploadFile
from faster_whisper import WhisperModel

app = FastAPI(title="Faster-Whisper API")


@app.post("/transcribe", summary="Transcribe an audio file")
async def transcribe_api(file: UploadFile = File(...)):
    if file.content_type is not None and not file.content_type.startswith("audio/"):
        raise HTTPException(status_code=400, detail="Uploaded file is not audio")

    model = cast(WhisperModel, app.extra["model"])
    segments, info = model.transcribe(io.BytesIO(file.file.read()), beam_size=5)

    return {
        "language": info.language,
        "language_probability": info.language_probability,
        "segments": [
            {"start": segment.start, "end": segment.end, "text": segment.text.strip()}
            for segment in segments
        ],
    }
