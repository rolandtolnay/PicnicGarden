import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

try {
  admin.initializeApp();
} catch (error) {
  console.error(error);
}

const messaging = admin.messaging();

export const notifications = functions
  .region("europe-west1")
  .https.onRequest(async (req, res) => {
    const message = req.body;
    try {
      await messaging.send(message);
      res.status(200).send("Successfully sent notifcation");
    } catch (error) {
      res.status(500).send(`${error}`);
    }
  });

export const onNewNotification = functions
  .region("europe-west1")
  .firestore.document(
    "restaurants/{restaurantId}/notifications/{notificationId}"
  )
  .onCreate(async (snap, _) => {
    //
    const notification = snap.data() as Notification;

    let message;

    const order = notification.order;
    if (order != null) {
      const title = `${order.recipe.name} ${order.currentStatus.name} @ ${order.table.name}`;
      message = {
        notification: {
          title: title,
        },
        data: {
          createdBy: notification.createdBy,
          tableId: order.table.id,
          sound: "squeak_toy.wav",
        },
        apns: {
          payload: {
            aps: {
              sound: "squeak_toy.wav",
            },
          },
        },
        condition: makeCondition(notification),
      };
    }

    const table = notification.table;
    if (table != null) {
      const title = `${table.name} updated to: ${table.status?.name}`;
      message = {
        notification: {
          title: title,
        },
        data: {
          createdBy: notification.createdBy,
          tableId: table.id,
          sound: "squeak_toy.wav",
        },
        apns: {
          payload: {
            aps: {
              sound: "squeak_toy.wav",
            },
          },
        },
        condition: makeCondition(notification),
      };
    }

    if (message != null) {
      console.log(`Sending message: ${JSON.stringify(message)}`);
      return messaging.send(message);
    } else {
      console.warn(`Unexpected notification: ${JSON.stringify(notification)}`);
      return Promise.resolve();
    }
  });

function makeCondition(notification: Notification) {
  return notification.topicNames.reduce(
    (accumulator, currentValue, currentIndex, _) => {
      if (currentIndex == 0) {
        return `'${currentValue}' in topics`;
      } else {
        return `${accumulator} || '${currentValue}' in topics`;
      }
    },
    ""
  );
}

interface Notification {
  createdBy: string;
  order: Order | undefined;
  table: Table | undefined;
  topicNames: string[];
}

interface Table {
  id: string;
  name: string;
  status: TableStatus | undefined;
}

interface TableStatus {
  name: string;
}

interface Order {
  recipe: Recipe;
  table: Table;
  currentStatus: OrderStatus;
}

interface Recipe {
  name: string;
}

interface OrderStatus {
  name: string;
}
