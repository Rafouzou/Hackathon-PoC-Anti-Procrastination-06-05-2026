const functions = require("firebase-functions");
const admin = require("firebase-admin");

const db = admin.firestore();
db.settings({ 
  databaseId: "(default)",
});

/**
 * Manual trigger for creating daily assignments (for testing)
 * Call via: POST https://us-central1-verifi-poc-hackathon.cloudfunctions.net/createDailyAssignmentsManual?date=2026-05-06
 * If no date provided, uses today's date
 */
exports.createDailyAssignmentsManual = functions.https.onRequest(
  async (req, res) => {
    try {
      // Debug logs -----------------------------------------------------------
      const projectId = admin.instanceId().app.options.projectId;
      console.log(`[DEBUG] Currently connected to Project: ${projectId}`);

      const collections = await db.listCollections();
      const collectionNames = collections.map(col => col.id);
      console.log(`[DEBUG] Collections found in DB: ${collectionNames.join(', ')}`);

      if (!collectionNames.includes('users')) {
          return res.status(404).json({ error: "'users' collection not found in this DB instance", found: collectionNames });
      }
      // ----------------------------------------------------------------------
      
      // Get date from query params or use today
      const dateParam = req.query.date || new Date().toISOString().split("T")[0];
      console.log(`Creating assignments for date: ${dateParam}`);

      // Get all users
      const usersSnapshot = await db.collection("users").get();

      // Debug logs -----------------------------------------------------------
      usersSnapshot.forEach(doc => {
        console.log(`[DEBUG] Found doc ID: ${doc.id}`);
      });

      console.log(`[DEBUG] Attempting to read 'users' collection. Count: ${usersSnapshot.size}`);

      if (usersSnapshot.empty) {
        console.log("[DEBUG] 'users' collection is empty or path is wrong.");
        return res.status(404).json({ error: "No users found" });
      }
      // ----------------------------------------------------------------------

      const users = usersSnapshot.docs.map((doc) => ({
        uid: doc.id,
        name: doc.data().displayName || "Unknown",
      }));

      let assignmentCount = 0;

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
            ownerId: user.uid,
            date: dateParam,
            verifyingUserId: randomVerifier.uid,
            verifierId: randomVerifier.uid,
            verifyingUserName: randomVerifier.name,
            taskIds: tasksSnapshot.docs.map((doc) => doc.id),
            status: "pending",
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          };

          await db
            .collection("dailyAssignments")
            .doc(`${dateParam}_${user.uid}`)
            .set(assignment);

          assignmentCount++;
          console.log(
            `Assigned ${randomVerifier.name} to verify ${user.name}'s tasks`
          );
        }
      }

      res.json({
        success: true,
        date: dateParam,
        assignmentsCreated: assignmentCount,
        message: `Created ${assignmentCount} assignments for ${dateParam}`,
      });
    } catch (error) {
      console.error("Error in createDailyAssignmentsManual:", error);
      res.status(500).json({ error: error.message });
    }
  }
);
