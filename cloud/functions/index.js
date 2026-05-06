import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

/**
 * Daily assignment function - runs at 6:00 AM UTC
 * Assigns each user (who has at least one verifiable task) a random person to verify
 * and marks them as needing to verify someone
 */
export const assignDailyVerifier = functions.pubsub
  .schedule("0 6 * * *") // 6 AM UTC daily
  .timeZone("UTC")
  .onRun(async (context) => {
    try {
      console.log("Starting daily verifier assignment...");

      // Get all users
      const usersSnapshot = await db.collection("users").get();
      if (usersSnapshot.empty) {
        console.log("No users found");
        return;
      }

      const users = usersSnapshot.docs.map((doc) => ({
        uid: doc.id,
        name: doc.data().displayName || "Unknown",
      }));

      const today = new Date().toISOString().split("T")[0];

      // For each user, get their verifiable tasks
      for (const user of users) {
        const tasksSnapshot = await db
          .collection("users")
          .doc(user.uid)
          .collection("tasks")
          .where("isVerifiable", "==", true)
          .get();

        // Only assign if user has verifiable tasks
        if (!tasksSnapshot.empty) {
          // Random user to verify (excluding self)
          const otherUsers = users.filter((u) => u.uid !== user.uid);
          if (otherUsers.length === 0) continue;

          const randomVerifier = 
            otherUsers[Math.floor(Math.random() * otherUsers.length)];

          const assignment = {
            uid: user.uid,
            date: today,
            verifyingUserId: randomVerifier.uid,
            verifyingUserName: randomVerifier.name,
            taskIds: tasksSnapshot.docs.map((doc) => doc.id),
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          };

          await db
            .collection("dailyAssignments")
            .doc(`${user.uid}_${today}`)
            .set(assignment);

          console.log(
            `Assigned ${randomVerifier.name} to verify ${user.name}'s tasks`
          );
        }
      }

      console.log("Daily verifier assignment completed");
    } catch (error) {
      console.error("Error in assignDailyVerifier:", error);
      throw error;
    }
  });

/**
 * Cleanup function - closes expired verification chats (after 24h)
 */
export const cleanupExpiredChats = functions.pubsub
  .schedule("0 7 * * *") // 7 AM UTC daily
  .timeZone("UTC")
  .onRun(async (context) => {
    try {
      console.log("Starting cleanup of expired chats...");

      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);

      // Find assignments older than 24 hours and mark them as closed
      const oldAssignments = await db
        .collection("dailyAssignments")
        .where("createdAt", "<", yesterday)
        .get();

      for (const doc of oldAssignments.docs) {
        await doc.ref.update({ status: "closed" });
      }

      console.log(`Closed ${oldAssignments.docs.length} expired chats`);
    } catch (error) {
      console.error("Error in cleanupExpiredChats:", error);
      throw error;
    }
  });
