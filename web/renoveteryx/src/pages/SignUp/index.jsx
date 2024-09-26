import React, { useState } from "react";
import { getAuth, createUserWithEmailAndPassword, GoogleAuthProvider, signInWithPopup } from "firebase/auth";
import { getFirestore, doc, setDoc } from "firebase/firestore"; // Firestore import
import "./loginStyle.css";
import { useNavigate } from "react-router-dom";

function Signup() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null); // Handle error messages
  const [success, setSuccess] = useState(null); // Handle success messages
  const navigate = useNavigate();

  // Function to validate email using regex
  const isValidEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  // Function to validate password strength
  const isValidPassword = (password) => {
    return password.length >= 8 && /[A-Z]/.test(password) && /[0-9]/.test(password);
  };

  async function handleSignUp(event) {
    event.preventDefault(); // Prevent page reload

    // Password Input validation
    if (!isValidPassword(password)) {
      setError("Password must be at least 8 characters long and include a number and an uppercase letter.");
      return;
    }

    // Email Input validation
    if (!isValidEmail(email)) {
      setError("Please enter a valid email address.");
      return;
    }

    setError(""); // Clear any previous errors
    const auth = getAuth(); // Initialize Firebase Auth
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
      setSuccess("");
      // Handle specific Firebase error codes
      if (error.code === "auth/email-already-in-use") {
        setError("An account with this email already exists. Please use a different email or login.");
      } else if (error.code === "auth/invalid-email") {
        setError("The email address is not valid. Please check and try again.");
      } else if (error.code === "auth/weak-password") {
        setError("The password is too weak. Please use a stronger password.");
      } else {
        setError("Failed to create account. Please try again.");
      }
      console.error("Error signing up:", error);
    }
  }

  const handleGoogleSignUp = async () => {
    const provider = new GoogleAuthProvider();
    const auth = getAuth();
    const db = getFirestore();

    try {
      const userCredential = await signInWithPopup(auth, provider);
      const user = userCredential.user;

      // Store user role as 'pmanager' in Firestore
      await setDoc(doc(db, "users", user.uid), {
        email: user.email,
        role: "pmanager", // Hardcoded role for all users
      });

      setSuccess("User signed up successfully with Google");
      console.log("User signed up with Google:", user);
      navigate("/login")
    } catch (error) {
      setSuccess("");
      console.error("Google sign-up error:", error);

      if (error.code === "auth/email-already-in-use") {
        setError("An account with this email already exists. Please use a different email or login.");
      } else {
        setError("Failed to sign up with Google. Please try again.");
      }
    }
  };

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
        
            <button onClick={handleGoogleSignUp} className="submit">
              Sign up with Google
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

