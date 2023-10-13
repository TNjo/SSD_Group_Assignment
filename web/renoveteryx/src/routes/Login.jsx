import React, { useState } from "react";
import { getAuth, signInWithEmailAndPassword } from "firebase/auth";
import { useNavigate } from "react-router-dom";

function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState();
  const navigate = useNavigate();

  async function handleLogin() {
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
    <div>
      <h1>Login</h1>
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
        <button type="button" onClick={handleLogin}>
          Sign up
        </button>
      </form>
    </div>
  );
}

export default Login;
