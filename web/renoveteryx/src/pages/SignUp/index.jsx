import React, { useState } from "react";
import { getAuth, createUserWithEmailAndPassword } from "firebase/auth";
import { getFirestore, doc, setDoc } from "firebase/firestore"; // Firestore import
import "./loginStyle.css";

function Signup() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null); // Handle error messages
  const [success, setSuccess] = useState(null); // Handle success messages

  async function handleSignUp(e) {
    e.preventDefault();
    const auth = getAuth(); // Initialize auth
    const db = getFirestore(); // Initialize Firestore

    try {
      const userCredential = await createUserWithEmailAndPassword(auth, email, password);
      const user = userCredential.user;

      // Store user role as 'pmanager' in Firestore
      await setDoc(doc(db, "users", user.uid), {
        email: user.email,
        role: "pmanager", // Hardcoded role for all users
      });

      setSuccess("User signed up successfully");
      console.log("User signed up:", user);
    } catch (error) {
      setError(error.message); // Set error message
      console.error("Error signing up:", error);
    }
  }

  return (
    <div className="background">
      <div className="login-container">
        <form className="form" onSubmit={handleSignUp}>
          <p className="form-title">Create Account</p>
          {error && <p className="error">{error}</p>} {/* Show error message */}
          {success && <p className="success">{success}</p>} {/* Show success message */}
          <div className="input-container">
            <label>Email:</label>
            <input
              type="email"
              placeholder="Enter email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div className="input-container">
            <label>Password:</label>
            <input
              type="password"
              placeholder="Enter password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          <button type="submit" className="submit">
            Sign up
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
