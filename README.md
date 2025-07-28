# Walkie Talkie - STT/TTS Service Stack

A Docker Compose stack providing unified Speech-to-Text (Whisper) and Text-to-Speech (Kokoro) services with a single API endpoint.

## Architecture

- **Whisper**: STT service using [onerahmet/openai-whisper-asr-webservice](https://ahmetoner.com/whisper-asr-webservice/)
- **Kokoro**: TTS service using [kokoro-fastapi-cpu image](https://github.com/remsky/Kokoro-FastAPI)
- **Nginx Gateway**: Unified API endpoint routing requests to appropriate services

1. Start services:
```bash
docker compose up -d
```

2. Test health:
```bash
curl http://localhost:8888/health
```

## API Endpoints

### Main Gateway (Port 8888)
- `GET /health` - Health check
- `POST /stt/*` - Speech-to-Text endpoints (proxied to Whisper)
- `POST /tts/*` - Text-to-Speech endpoints (proxied to Kokoro)

### Direct Service Access
- **Whisper**: http://localhost:9000 
- **Kokoro**: http://localhost:8880  http://localhost:8880/docs  http://localhost:8880/web

## Usage Examples

### Speech-to-Text
```bash
curl -X POST -F 'audio_file=@audio.wav' http://localhost:8888/stt/asr
```

### Text-to-Speech  
```bash
curl -X POST http://localhost:8888/tts/v1/audio/speech \
  -H 'Content-Type: application/json'   -d '{"input": "Hello world", "voice": "af_jadzia"}' --output test.mp3
```


## GPU vs CPU

- **GPU version**: Use `compose.yaml` (requires NVIDIA GPU + nvidia-docker)
- **CPU version**: Use `compose-cpu.yaml` for CPU-only deployment

## MCP Integration

This stack provides standard HTTP endpoints that MCP servers can easily integrate with:

```python
# Example MCP server integration (check exact API specs for arguments and returns)
import requests

def transcribe_audio(audio_file_path):
    with open(audio_file_path, 'rb') as f:
        response = requests.post(
            'http://localhost:8888/stt/asr',
            files={'audio_file': f}
        )
    return response.json()

def synthesize_speech(text):
    response = requests.post(
        'http://localhost:8888/tts/v1/audio/speech',
        json={'input': text}
    )
    return response.content  # Audio data
```

