# Firestore Schema

## Authentication

Note: Users sign up with **username + password**. Usernames are internally converted to emails in the format `username@verifi.local` for Firebase Authentication.

## Collections

### users

User account information.

```json
{
  "uid": "user_id",
  "email": "user@example.com",
  "displayName": "John Doe",
  "createdAt": "2026-05-06T10:30:00Z",
  "tasksCount": 5
}
```

**Subcollection: `tasks`**

User's tasks.

```json
{
  "id": "task_id",
  "uid": "user_id",
  "title": "Run 5km",
  "description": "Morning jog before work",
  "deadline": "2026-05-07T09:00:00Z",
  "isVerifiable": true,
  "status": "pending",
  "createdAt": "2026-05-06T10:30:00Z"
}
```

Task Status Values:
- `pending` - Waiting for verification
- `verified` - Task was verified by another user
- `rejected` - Task was rejected during verification

### dailyAssignments

Daily assignments for users to verify.

```json
{
  "uid": "user_id_being_verified",
  "date": "2026-05-06",
  "verifyingUserId": "verifier_id",
  "verifyingUserName": "Jane Smith",
  "taskIds": ["task_id_1", "task_id_2"],
  "status": "active",
  "createdAt": "2026-05-06T06:00:00Z"
}
```

Document ID format: `{uid}_{date}` (e.g., `user123_2026-05-06`)

Status Values:
- `active` - Verification is ongoing
- `closed` - 24 hours have passed

### messages

Chat messages during verification.

```json
{
  "taskId": "task_id",
  "senderId": "user_id",
  "receiverId": "user_id",
  "content": "I ran 5km this morning",
  "proofType": "text",
  "imageUrl": null,
  "timestamp": "2026-05-06T14:30:00Z",
  "isFromVerifier": false
}
```

Proof Type Values:
- `text` - Written proof
- `image` - Photo proof

## Indexing

Recommended indexes:

```
Collection: users/tasks
- deadline (Ascending)
- isVerifiable (Ascending)
- status (Ascending)
- createdAt (Descending)

Collection: dailyAssignments
- createdAt (Descending)
- status (Ascending)
```

## Security Rules

See `firestore.rules` for full security rules.

Key principles:
- Users can only read/write their own data
- Users can read tasks assigned to them for verification
- Only server (Cloud Functions) can write assignments
- Messages are private to conversation participants
