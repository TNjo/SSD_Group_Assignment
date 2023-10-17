import React, { useState } from "react";
import { getAuth, createUserWithEmailAndPassword } from "firebase/auth";
import "./loginStyle.css";
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
    <div className="background">
      <div className="login-container">
        <form className="form" onSubmit={handleSignUp}>
          <p className="form-title">Create Account</p>
          <div className="input-container">
            <label>Email:</label>
            <input
              type="email"
              placeholder="Enter email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </div>
          <div className="input-container">
            <label>Password:</label>
            <input
              type="password"
              placeholder="Enter password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>
          <button type="submit" className="submit">
            Sign in
          </button>
          <p className="signup-link">
           Already have an account? <a href="/login">Login</a>
            
          </p>
        </form>
      </div>
    </div>
  );
}

export default Signup;
