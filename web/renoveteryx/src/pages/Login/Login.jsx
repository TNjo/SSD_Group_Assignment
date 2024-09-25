
import React, { useState, useEffect } from "react";
import { getAuth, signInWithEmailAndPassword } from "firebase/auth";
import { useNavigate } from "react-router-dom";
import ReCAPTCHA from "react-google-recaptcha";
import "./loginStyle.css"; // Your existing styles

function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [captchaToken, setCaptchaToken] = useState(null);
  const [captchaError, setCaptchaError] = useState(false);
  const [failedAttempts, setFailedAttempts] = useState(0);
  const [lockoutTime, setLockoutTime] = useState(0); // Time remaining until lockout ends
  const [lockoutActive, setLockoutActive] = useState(false);

  const navigate = useNavigate();

  useEffect(() => {
    // Timer to reset the lockout
    let timer;
    if (lockoutActive && lockoutTime > 0) {
      timer = setInterval(() => {
        setLockoutTime((prevTime) => prevTime - 1);
      }, 1000);
    } else if (lockoutTime === 0) {
      setLockoutActive(false);
      setFailedAttempts(0); // Reset failed attempts after lockout ends
    }
    return () => clearInterval(timer); // Cleanup on unmount
  }, [lockoutActive, lockoutTime]);

  const handleCaptcha = (token) => {
    setCaptchaToken(token);
    setCaptchaError(false);
  };

  const handleLogin = async (e) => {
    e.preventDefault();

    // Ensure the CAPTCHA is completed
    if (!captchaToken) {
      setCaptchaError(true);
      return;
    }

    // Check if the account is locked out
    if (lockoutActive) {
      alert(`Account locked. Please wait ${lockoutTime} seconds.`);
      return;
    }

    const auth = getAuth();

    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const user = userCredential.user;

      console.log("User signed in:", user);
      const emailDomain = user.email.split("@")[1];

      // Redirect based on email domain
      if (emailDomain === "gmail.com") {
        navigate("/pm");
      } else if (emailDomain === "example.com") {
        navigate("/admin-home");
      }
    } catch (error) {
      console.error("Login error:", error);
      alert(error.message);
      setFailedAttempts((prevAttempts) => prevAttempts + 1);
      

      // Lock out if too many failed attempts
      if (failedAttempts + 1 >= 5) {
        setLockoutActive(true);
        setLockoutTime(30); // Lockout for 30 seconds
      }
    }
  };

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
          {/* Add reCAPTCHA */}
          <ReCAPTCHA
            sitekey="6Leq200qAAAAAC8J1uMY2HyC51LMwHZU4lOGhJSZ" // Replace with your actual site key
            onChange={handleCaptcha}
            onExpired={() => setCaptchaToken(null)}
          />
          {captchaError && <p style={{ color: "red" }}>Please complete the CAPTCHA verification.</p>}
          <button type="submit" className="submit" disabled={lockoutActive}>
            Sign in
          </button>
          {lockoutActive && (
            <p style={{ color: "red" }}>Too many failed attempts. Try again in {lockoutTime} seconds.</p>
          )}
          <p className="signup-link">
            No account? <a href="/signup">Sign up</a>
          </p>
        </form>
      </div>
    </div>
  );
}

export default Login;



