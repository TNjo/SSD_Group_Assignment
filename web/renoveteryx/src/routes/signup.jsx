import React, { useState } from "react";
import { getAuth, createUserWithEmailAndPassword } from "firebase/auth";

function Signup() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState();

  async function handleSignUp() {
    const auth = getAuth(); // Move this inside the function

    createUserWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        // Signed in
        const user = userCredential.user;
        console.log("User signed up:", user);
      })
      .catch((error) => {
        const errorCode = error.code;
        const errorMessage = error.message;
        console.error("Error: " + errorCode, errorMessage);
      });
  }

  return (
    <div>
      <h1>Signup</h1>
      <form>
        <input
          type="text"
          placeholder="Email"
          onChange={(e) => setEmail(e.target.value)}
        />
        <input
          type="password"
          placeholder="Password"
          onChange={(e) => setPassword(e.target.value)}
        />
        <button type="button" onClick={handleSignUp}>
          Sign up
        </button>
      </form>
    </div>
  );
}

export default Signup;
