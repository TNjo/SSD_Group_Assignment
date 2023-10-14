import React, { useState } from "react";
import { getAuth, signInWithEmailAndPassword } from "firebase/auth";
import { useNavigate } from "react-router-dom";
import "./loginStyle.css";
function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const navigate = useNavigate();

  async function handleLogin(e) {
    e.preventDefault(); // Prevent the default form submission

    const auth = getAuth();

    signInWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        // Signed in
        const user = userCredential.user;
        console.log("User signed up:", user);

        // Determine the redirect based on the email domain
        const emailDomain = user.email.split("@")[1]; // Get the domain part of the email

        if (emailDomain === "gmail.com") {
          navigate("/");
        } else if (emailDomain === "example.com") {
          navigate("/admin-home");
        }
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
        <form className="form" onSubmit={handleLogin}>
          <p className="form-title">Login In To Your Account</p>
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
            No account?
            <a href="#">Sign up</a>
          </p>
        </form>
      </div>
    </div>
  );
}

export default Login;
