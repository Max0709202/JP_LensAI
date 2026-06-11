# Japan Lens AI

Japan Lens AI is a Flutter MVP for travelers in Japan. It helps users understand signs, menus, emergency phrases, etiquette, and common travel situations with mock AI responses.

Tagline: **Point your camera. Understand Japan.**

## MVP Status

- Mock AI mode only. No API key is required.
- Android APK is the first target.
- The code uses Flutter cross-platform patterns and keeps future iOS work isolated in platform configuration.
- Local saved phrases are stored with `shared_preferences`.

## Run

```bash
flutter pub get
flutter run
```

## Build Android APK

```bash
flutter pub get
flutter build apk --release
```

## Future iOS Preparation

Before an iOS release:

- Open the generated iOS project in Xcode.
- Set the iOS bundle identifier, likely `com.japanlens.ai`.
- Configure an Apple Developer account and signing team.
- Add camera and photo library usage descriptions to `ios/Runner/Info.plist`.
- Configure App Store Connect and TestFlight.
- Review iOS payment/subscription setup with Stripe or RevenueCat if premium plans are added.
- Verify image picker behavior on physical iOS devices.

## Future Backend Flow

Mobile app -> user takes photo -> upload image or extract OCR text -> backend API -> OCR / Vision AI -> LLM structured JSON response -> app result UI.

Future endpoints prepared in `RemoteAiService`:

- `POST /api/analyze-sign`
- `POST /api/analyze-menu`
- `POST /api/etiquette-answer`

## Not Implemented In MVP

Real OCR, real AI, user accounts, payments, cloud databases, push notifications, production analytics, app store release, and Google Play release are intentionally out of scope.
