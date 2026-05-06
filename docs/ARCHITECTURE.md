# Verifi Architecture

## Overview

Verifi is a Flutter mobile and web app powered by Google Cloud serverless infrastructure.

## Tech Stack

### Frontend
- **Flutter** - Cross-platform (iOS, Android, Web)
- **Dart** - Programming language
- **Firebase SDK** - Authentication, Firestore, Cloud Messaging

### Backend
- **Firestore** - NoSQL database
- **Firebase Authentication** - User management
- **Cloud Functions** - Scheduled jobs, business logic
- **Cloud Scheduler** - Trigger daily assignments
- **Firebase Cloud Messaging** - Push notifications
- **Cloud Storage** - Proof image uploads (optional)
- **Vertex AI Gemini** - Task parsing AI (optional)

## Data Flow

### User Authentication
1. User signs up/in via Flutter app
2. Firebase Auth validates credentials
3. User document created in Firestore
4. Auth state stream updates UI

### Task Creation
1. User fills task form in app
2. App calls TaskService.createTask()
3. Data written to `users/{uid}/tasks/{taskId}`
4. Optional: Gemini API parses free text into structured task

### Daily Assignment
1. Cloud Scheduler triggers at 6 AM UTC
2. Cloud Function `assignDailyVerifier()` runs
3. Function queries all active users
4. For each user with verifiable tasks:
   - Random user selected as verifier
   - Assignment document created
   - Notification sent via FCM
5. App receives notification, shows badge

### Verification Flow
1. Verifier opens app → sees assignment notification
2. App loads their assigned tasks to verify
3. Verifier reviews each task, uploads/provides proof
4. Verifier submits verification (verified/rejected)
5. Task status updated in Firestore
6. Original user receives notification of verification result

## Database Schema

```
users/
├── {uid}
    ├── uid: string
    ├── email: string
    ├── displayName: string
    ├── createdAt: timestamp
    ├── tasksCount: number
    └── tasks/
        └── {taskId}
            ├── id: string
            ├── uid: string
            ├── title: string
            ├── description: string
            ├── deadline: timestamp
            ├── isVerifiable: boolean
            ├── status: enum (pending|verified|rejected)
            └── createdAt: timestamp

dailyAssignments/
├── {uid}_{date}
    ├── uid: string
    ├── date: string (YYYY-MM-DD)
    ├── verifyingUserId: string
    ├── verifyingUserName: string
    ├── taskIds: array
    ├── status: enum (active|closed)
    └── createdAt: timestamp

messages/
├── {messageId}
    ├── taskId: string
    ├── senderId: string
    ├── receiverId: string
    ├── content: string
    ├── proofType: enum (text|image)
    ├── imageUrl: string (optional)
    ├── timestamp: timestamp
    └── isFromVerifier: boolean
```

## Deployment Pipeline

### Flutter App
- Build for iOS/Android via Xcode/Android Studio
- Deploy via App Store / Google Play / Web hosting

### Cloud Functions
- Deploy via Firebase CLI: `firebase deploy --only functions`
- Functions auto-scale based on demand

### Firestore Rules
- Deploy via Firebase CLI
- Rules are stateless, evaluated for each request

## Development Setup

1. Clone repository
2. Configure Flutter environment
3. Set up Firebase project
4. Update `firebase_options.dart` with your credentials
5. Run `flutter pub get`
6. Run `flutter run` for dev
7. Deploy Cloud Functions when ready

## Future Enhancements

- Reputation/karma system
- Group challenges
- Task templates
- Advanced Gemini integration
- Image/video proof uploads
- Social features (teams, leaderboards)
- Analytics dashboard
