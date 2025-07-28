# Walkie Talkie - STT/TTS Service Stack

A Docker Compose stack providing unified Speech-to-Text (Whisper) and Text-to-Speech (Kokoro) services with a single API endpoint.

## Architecture

- **Whisper**: STT service using whisperdock (onerahmet/openai-whisper-asr-webservice)
- **Kokoro**: TTS service using official kokoro-fastapi-cpu image  
- **Nginx Gateway**: Unified API endpoint routing requests to appropriate services

2. Start services:
```bash
docker compose up -d
```

3. Test health:
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
- **Kokoro**: http://localhost:8880

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

## Configuration

Edit `.env` file to customize:
- `ASR_MODEL`: Whisper model size (tiny, base, small, medium, large)
- `USE_GPU`: Enable GPU support (requires nvidia-docker)
- Port configurations

## GPU vs CPU

- **GPU version**: Use `compose.yaml` (requires NVIDIA GPU + nvidia-docker)
- **CPU version**: Use `compose-cpu.yaml` for CPU-only deployment

## MCP Integration

This stack provides standard HTTP endpoints that MCP servers can easily integrate with:

```python
# Example MCP server integration
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
        'http://localhost:8888/tts/',
        json={'text': text}
    )
    return response.content  # Audio data
```

## Troubleshooting

- Check service logs: `docker compose logs [service-name]`
- Verify GPU access: `docker compose logs whisper`
- Test individual services using direct ports if gateway issues occur
