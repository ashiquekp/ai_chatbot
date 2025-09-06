# Flutter AI Chatbot (Offline + Online)

A chat UI that works offline with `assets/faq.json` and can switch to online mode (OpenAI-style API).
Riverpod for state, clean chat bubbles, typing indicator, and local chat history.

## Features
- Offline mode: exact/contains matching over FAQ JSON.
- Online mode: call OpenAI-like API via HTTP.
- Save/restore chat history with SharedPreferences.
- Typing indicator, bubble UI, Material 3.

## Setup
1. `flutter pub get`
2. Add your API key & base URL in `lib/services/chatbot_service.dart`.
3. Run: `flutter run`.

## Screenshots
(Add after running)
