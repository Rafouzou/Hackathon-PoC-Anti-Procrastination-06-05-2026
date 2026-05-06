# Verifi - Anti-Procrastination App

Fight procrastination together through social accountability.

## Problem Statement

1. **Forgotten tasks** → Users don't remember what they committed to
2. **Wrong timing mindset** → "It's not the right moment" becomes an excuse
3. **Fear of judgment** → Social pressure prevents task avoidance
4. **Time illusion** → "I have more time" leads to pushing things back

## Solution

Verifi combines:
- **Task management** - Create, track, and manage daily tasks
- **Reminders** - Get notified about upcoming deadlines
- **Social accountability** - Daily peer verification of task completion
- **AI assistance** - Smart task parsing to reduce friction

## Key Features

### Authentication
- Simple username + password signup and login
- No email required for MVP
- Usernames auto-converted to internal Firebase emails

### Task Management
- Create tasks with deadlines
- Mark tasks as verifiable or confidential
- Track task status (pending, verified, rejected)

### Daily Verification Duty
Every day, each user with verifiable tasks gets:
- **One random peer** assigned to verify their tasks
- **Receives verification** from another random peer
- Access to a temporary 24-hour chat to discuss proof

### Gamification Elements
- Verification streaks
- Task completion badges
- Accountability network

## Tech Stack

### Frontend
- Flutter (mobile + web)
- Dart

### Backend
- Firebase (Auth, Firestore)
- Cloud Functions
- Cloud Scheduler

### Optional
- Vertex AI Gemini (task parsing)

## Project Structure

```
verifi/
├── verifi/              # Flutter app
│   ├── lib/
│   │   ├── screens/
│   │   ├── services/
│   │   ├── models/
│   │   ├── widgets/
│   │   ├── theme/
│   │   └── main.dart
│   └── pubspec.yaml
│
├── cloud/               # Backend
│   ├── functions/       # Cloud Functions
│   └── firestore.rules
│
└── docs/               # Documentation
```

## Getting Started

### Prerequisites
- Flutter SDK 3.10+
- Firebase account
- Node.js 20+ (for Cloud Functions)

### Local Development

1. **Setup Flutter**
   ```bash
   cd verifi
   flutter pub get
   flutter run
   ```

2. **Setup Firebase**
   ```bash
   flutterfire configure --platforms=android,ios,web
   ```

3. **Run with Emulator**
   ```bash
   firebase emulators:start
   ```

### Deployment

See [DEPLOYMENT.md](docs/DEPLOYMENT.md) for production setup.

## Design System

- **Primary Color**: Yellow (#FFC300)
- **Secondary Colors**: Black (#000000), White (#FFFFFF)
- **Typography**: Poppins (headlines), Inter (body)
- **Style**: Modern, bold color blocks, clean animations

## API Reference

See [API.md](docs/API.md) for detailed endpoints and data structures.

## Architecture

See [ARCHITECTURE.md](docs/ARCHITECTURE.md) for system design.

## Database Schema

See [SCHEMA.md](docs/SCHEMA.md) for Firestore structure.

## Team

Built by Raphaël Brenn (github.com/Rafouzou) for PoC anti Procrastination Hackathon 2026
