# Verifi: Stop Procrastinating, Start Verifying

Verifi is an anti-procrastination app that uses social accountability to help you get things done. Instead of just tracking tasks, you commit to them, and a peer verifies that you've actually done the work.

## How it works

1. Create Tasks: Add your daily goals in the app.
2. Accountability Match: Every day, the system pairs you with another user.
3. Verify & Chat: You verify your partner's tasks, and they verify yours. You get a temporary, 24-hour chat to share proof and keep each other on track.
4. Build Streaks: Consistent completion and verification earn you streaks and status.

## Why it works
By introducing a "peer review" element, Verifi eliminates the easy excuses. You aren't just letting yourself down—you're answering to a partner.

---

## How to run the project

### 1. Requirements
* Flutter SDK (https://docs.flutter.dev/get-started/install) installed.
* Firebase CLI (https://firebase.google.com/docs/cli) installed and configured.

### 2. Setup
1. Clone the repo: git clone <your-repo-url>
2. Install dependencies:
   ```bash
   cd verifi
   flutter pub get
   ```
3. Configure Firebase:
   Ensure you are logged into Firebase and have access to the project:
   ```bash
   firebase login
   firebase use --add
   ```

### 3. Running Locally
Use the Firebase Emulator to test the backend without affecting production data:
```bash
# Start the emulators
firebase emulators:start
```
Then, in a new terminal window:
```bash
# Start the Flutter app
cd verifi
flutter run
```

---
*Built for the 2026 PoC Anti-Procrastination Hackathon.*
