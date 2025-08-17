from pathlib import Path

from faster_whisper import WhisperModel
from rich import print
from typer import Typer

cli = Typer()


@cli.command()
def scribe(file: Path, model: str = "small"):
    """Transcribe an audio file using the Faster-Whisper model."""

    whisper = WhisperModel(model)
    segments, info = whisper.transcribe(file.as_posix(), beam_size=5)
    print(f"Language: {info.language} (Probability: {info.language_probability})")
    for segment in segments:
        print(f"[{segment.start:.2f}s - {segment.end:.2f}s] {segment.text.strip()}")


@cli.command(context_settings={"auto_envvar_prefix": "A555CRIBE"})
def serve(host: str = "127.0.0.1", port: int = 8000, model: str = "small"):
    """Start the API server."""

    import uvicorn

    from .api import app

    app.extra["whisper"] = WhisperModel(model)
    uvicorn.run(app, host=host, port=port)


if __name__ == "__main__":
    cli()
