# a555cribe

[![Build Status](https://img.shields.io/github/actions/workflow/status/acidghost/a555cribe/ci.yaml)](https://github.com/acidghost/a555cribe/actions)
[![License](https://img.shields.io/github/license/acidghost/a555cribe.svg)](LICENSE)

> **:writing_hand: A 555 audio transcription CLI and API powered by Faster Whisper**

## Description

This project provides a command-line interface and REST API for audio
transcription using OpenAI's Whisper model via the faster-whisper
implementation. It offers both local CLI usage and web API deployment options
with Docker and Kubernetes support.

## Quick start

### Using uv

Clone the repository and simply run:

```bash
uv run a555cribe --help
```

### Using Docker

Use the pre-built image:

```bash
docker run --pull --rm -p 8000:8000 ghcr.io/acidghost/a555cribe:latest
```

Or build from source:

```bash
docker build -t a555cribe .
docker run --rm -p 8000:8000 a555cribe
```

## Usage

### CLI transcription

Transcribe an audio file:

```bash
a555cribe scribe path/to/audio.file
```

### API server

Start the API server (will be available at http://localhost:8000):

```bash
a555cribe serve
```

## Configuration

The application uses environment variables for configuration:

- `A555CRIBE_PORT`: Server port (default: 8000)
- `A555CRIBE_HOST`: Server host (default: 0.0.0.0)
- `A555CRIBE_MODEL`: Whisper model to use (default: "small")

## Development

```bash
# Install development dependencies
uv sync --locked --all-extras --dev

# Run linting
uv run ruff check
uv run ruff format
```

### Cloud native development

Use [Skaffold](https://skaffold.dev/) for cloud native development:

```bash
skaffold dev
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the GNU Affero General Public License v3.0 - see
the [LICENSE](LICENSE) file for details.
