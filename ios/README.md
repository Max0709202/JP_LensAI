# iOS Preparation Notes

This MVP is Android-first but the Flutter code is iOS-ready.

Future iOS release checklist:

- Run `flutter create . --platforms=ios` if the iOS wrapper needs to be regenerated.
- Set bundle identifier to `com.japanlens.ai` in Xcode.
- Configure Apple Developer signing.
- Add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` to `Runner/Info.plist`.
- Prepare App Store Connect, TestFlight, subscription/payment configuration, and privacy labels.
