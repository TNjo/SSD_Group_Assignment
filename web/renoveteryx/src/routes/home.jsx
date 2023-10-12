import React from "react";
import { getAuth, signOut } from "firebase/auth";

function home() {
  const auth = getAuth();
  async function handleLogout() {
    await signOut(auth)
      .then(() => {
        console.log("User signed out");
      })
      .catch((error) => {
        console.error("Error: " + error);
      });
  }
  return (
    <div>
      <h1>home</h1>
      <button type="button" onClick={handleLogout}>
        Logout
      </button>
    </div>
  );
}

export default home;
