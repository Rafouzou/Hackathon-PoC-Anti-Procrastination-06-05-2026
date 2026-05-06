# Deployment Guide

## Prerequisites

- Flutter SDK 3.10+
- Node.js 20+
- Firebase account
- Firebase CLI

## Google Cloud Setup

### 1. Create Firebase Project

```bash
# Visit https://console.firebase.google.com
# Create new project "verifi"
```

### 2. Install Firebase CLI

```bash
npm install -g firebase-tools
firebase login
firebase init
```

### 3. Generate Firebase Options

```bash
# For Android
flutterfire configure --platforms=android,ios,web
```

This generates `lib/firebase_options.dart` with your credentials.

## Flutter App Deployment

### Android

```bash
cd verifi
flutter pub get
flutter build apk
# Upload APK to Google Play Store
```

### iOS

```bash
flutter build ios
# Open in Xcode, sign with Apple ID, upload to App Store
```

### Web

```bash
flutter build web
firebase deploy --only hosting
```

## Cloud Functions Deployment

```bash
cd cloud/functions
npm install
firebase deploy --only functions
```

Functions will deploy and automatically trigger on schedule:
- `assignDailyVerifier` - 6 AM UTC daily
- `cleanupExpiredChats` - 7 AM UTC daily

## Firestore Rules Deployment

```bash
firebase deploy --only firestore:rules
```

## Environment Configuration

### Local Development

Use Firebase Emulator Suite:

```bash
firebase emulators:start
```

This starts:
- Firestore emulator on localhost:8080
- Functions emulator
- Auth emulator

Update `firebase_options.dart` to point to localhost for emulators.

### Production

Ensure these settings in Firebase Console:

1. **Authentication**
   - Enable Email/Password provider
   - Set redirect URL for web

2. **Firestore**
   - Set region (us-central1 recommended)
   - Enable backups

3. **Cloud Functions**
   - Monitor via Cloud Console
   - Set up alerting for errors

4. **Cloud Storage** (if adding images)
   - Enable bucket
   - Set CORS rules

## Monitoring

```bash
# View Cloud Functions logs
firebase functions:log

# View Firestore usage
gcloud firestore operations list

# View errors in Cloud Console
# https://console.cloud.google.com
```

## Scaling Considerations

- Firestore auto-scales read/write capacity
- Cloud Functions auto-scale based on demand
- Use composite indexes for complex queries
- Monitor costs in Firebase Console

## Troubleshooting

### Functions not deploying

```bash
# Ensure Node version is 20+
node --version

# Clear cache and retry
rm -rf cloud/functions/node_modules
npm install
firebase deploy --only functions
```

### Auth not working

- Ensure Firebase project ID matches `firebase_options.dart`
- Check enable auth providers (Username/Password) in Firebase Console
- Username is auto-converted to internal email format (`username@verifi.local`)
- Verify user exists in authentication system

### Firestore permission denied

- Check security rules are deployed
- Verify user is authenticated
- Ensure user document exists in Firestore after signup
- Check collection/document paths match rules
