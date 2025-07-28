#!/bin/bash

echo "Testing Walkie Talkie API endpoints..."

# Test health endpoint
echo "1. Testing health endpoint..."
curl -s http://localhost:8888/health | jq .

echo -e "\n2. Testing Whisper STT endpoint..."
# Test whisper directly (you'll need to provide an audio file)
echo "curl -X POST -F 'audio_file=@your_audio.wav' http://localhost:8888/stt/asr"

echo -e "\n3. Testing Kokoro TTS endpoint..."  
# Test kokoro directly
echo "curl -X POST http://localhost:8888/tts/ -H 'Content-Type: application/json' -d '{\"text\": \"Hello world\"}'"

echo -e "\n4. Direct service tests (if needed):"
echo "Whisper direct: curl http://localhost:9000/"
echo "Kokoro direct: curl http://localhost:8880/"

echo -e "\nNote: Replace 'your_audio.wav' with an actual audio file for STT testing"
