//config.js

const firebase = require("firebase-admin");
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
      authDomain: "fluttercrud-fe6da.firebaseapp.com",
      projectId: "fluttercrud-fe6da",
      storageBucket: "fluttercrud-fe6da.appspot.com",
      messagingSenderId: "469330266003",
      appId: "1:469330266003:android:d05af3400db1345c078a66",
  };

// Initialize Firebase
const app = firebase.initializeApp(firebaseConfig);

// Reference to Firestore
const db = app.firestore();

// Check if Firebase is connected
db.collection("Employee").get()
    .then(() => {
        console.log("Firebase is connected!");
    })
    .catch((error) => {
        console.error("Error connecting to Firebase:", error);
    });

// Export collections or other Firebase components as needed
module.exports = {
    db, // You can export the Firestore instance if needed
    User: db.collection("Users"),
};
