# Verifi - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites
- Flutter SDK 3.10+ installed
- Firebase project configured (verifi-poc-hackathon)
- An IDE (VS Code recommended)

### 1. Install dependencies

```bash
cd verifi
flutter pub get
```

### 2. Run the app

#### Web (Recommended for quick testing)
```bash
flutter run -d edge
```

#### Windows desktop
```bash
flutter run -d windows
```

#### Mobile
```bash
# iOS (macOS only)
flutter run -d ios

# Android
flutter run -d android
```

### 3. Test authentication

**Signup:**
- Username: `testuser`
- Password: `Test1234!`
- Confirm: `Test1234!`

**Login:**
- Username: `testuser`
- Password: `Test1234!`

Note: Usernames are automatically converted to internal Firebase emails for authentication.

## Current Features ✅

- ✅ Authentication (username + password)
- ✅ Firebase integration
- ✅ Design system (yellow/black/white theme)
- ✅ Loading animations
- 🔄 Task management (in progress)
- ⏳ Verification system (coming soon)
- ⏳ Notifications (coming soon)

## Next Steps

1. Create tasks with deadlines
2. Mark tasks as verifiable
3. Daily peer verification assignments
4. Temporary chat interface
5. Push notifications

## 📁 Project Structure

```
verifi/
├── lib/
│   ├── screens/          # UI screens
│   │   ├── auth/         # Login/signup screens ✅
│   │   ├── tasks/        # Task management (WIP)
│   │   └── verification/ # Verification UI (coming)
│   ├── services/         # Firebase logic
│   ├── models/           # Data models
│   ├── widgets/          # Reusable components
│   ├── theme/            # Design system
│   └── main.dart         # Entry point
├── cloud/                # Backend
│   ├── functions/        # Cloud Functions
│   └── firestore.rules   # Security rules
└── docs/                 # Documentation
```

## 🎨 Design System

- **Primary**: Yellow (#FFC300)
- **Secondary**: Black, White
- **Components**: VerifiButton, VerifiCard, VerifiLoader
- **Theme**: Modern, bold color blocks

## 🔗 Firebase Setup

Your Firebase project is already configured with:
- Authentication enabled
- Firestore ready
- Cloud Functions permissions set
- Security rules deployed

To redeploy rules:
```bash
firebase deploy --only firestore:rules
```

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| App shows blank page | Rebuild: `flutter clean && flutter pub get` |
| Auth credentials rejected | Use test username: `testuser`, password: `Test1234!` |
| Firestore errors | Check rules: `firebase deploy --only firestore:rules` |
| FCM warnings on web | Normal - messaging not required for MVP |

## 📚 Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Database Schema](docs/SCHEMA.md)
- [Deployment](docs/DEPLOYMENT.md)

## ✨ What's Next

Working on **Phase 2: Task CRUD**
- Task list view
- Create/edit form
- Firestore integration
- Verifiable toggle

---

**Build time so far: ~2 hours**
**Estimated to MVP: 4 more hours**
