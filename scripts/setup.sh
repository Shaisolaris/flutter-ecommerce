#!/bin/bash
set -e
echo "🚀 Setting up flutter-ecommerce..."
command -v flutter >/dev/null 2>&1 || { echo "❌ Flutter SDK required. Install from https://flutter.dev"; exit 1; }
flutter create . --project-name app 2>/dev/null || true
flutter pub get
echo "✅ Ready! Run: flutter run"
