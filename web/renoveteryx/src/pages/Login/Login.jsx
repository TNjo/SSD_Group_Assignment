import React, { useState, useEffect } from "react";
import { getAuth, signInWithEmailAndPassword, GoogleAuthProvider, signInWithPopup } from "firebase/auth";
import { getFirestore, collection, addDoc, doc, getDoc } from "firebase/firestore";
import { useNavigate } from "react-router-dom";
import ReCAPTCHA from "react-google-recaptcha";
import emailjs from "emailjs-com";
import { getAnalytics, logEvent } from "firebase/analytics";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import "./loginStyle.css";

function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [captchaToken, setCaptchaToken] = useState(null);
  const [captchaError, setCaptchaError] = useState(false);
  const [failedAttempts, setFailedAttempts] = useState(0);
  const [lockoutTime, setLockoutTime] = useState(0);
  const [lockoutActive, setLockoutActive] = useState(false);
  const [verificationCode, setVerificationCode] = useState("");
  const [sentVerificationCode, setSentVerificationCode] = useState(null);
  const [verificationStep, setVerificationStep] = useState(false);
  const [verificationError, setVerificationError] = useState(false);

  const navigate = useNavigate();
  const auth = getAuth();
  const db = getFirestore();
  const analytics = getAnalytics(); // Initialize Analytics
  const siteKey = String(process.env.REACT_APP_RECAPTCHA_SITE_KEY)

  useEffect(() => {
    let timer;
    if (lockoutActive && lockoutTime > 0) {
      timer = setInterval(() => {
        setLockoutTime((prevTime) => prevTime - 1);
      }, 1000);
    } else if (lockoutTime === 0) {
      setLockoutActive(false);
      setFailedAttempts(0);
    }
    return () => clearInterval(timer);
  }, [lockoutActive, lockoutTime]);

  const handleCaptcha = (token) => {
    setCaptchaToken(token);
    setCaptchaError(false);
    logEvent(analytics, 'captcha_completed'); // Log CAPTCHA completion
  };

  const generateVerificationCode = () => {
    return Math.floor(100000 + Math.random() * 900000).toString();
  };

  const sendVerificationCode = (email, code) => {
    const templateParams = {
      to_email: email,
      verificationCode: code,
    };

    emailjs
      .send(
        "service_6fiu4br",
        "template_9z1ykku",
        templateParams,
        "lQRpj0D8qILcylxwq"
      )
      .then(
        (response) => {
          console.log("Verification code sent successfully", response.status, response.text);
          logEvent(analytics, 'verification_code_sent', { email }); // Log code sent
        },
        (err) => {
          console.error("Failed to send verification code:", err);
        }
      );
  };

  const logToFirestore = async (logData) => {
    try {
      await addDoc(collection(db, "loginLogs"), logData);
    } catch (error) {
      console.error("Failed to log to Firestore:", error);
    }
  };

  const handleLogin = async (e) => {
    e.preventDefault();

    if (!captchaToken) {
      setCaptchaError(true);
      logEvent(analytics, 'captcha_failed'); // Log CAPTCHA failure
      return;
    }

    if (lockoutActive) {
      alert(`Account locked. Please wait ${lockoutTime} seconds.`);
      return;
    }

    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const user = userCredential.user;

      const userDoc = await getDoc(doc(db, "users", user.uid));
      const userData = userDoc.data();
      const userRole = userData?.role || "pmanager";

      document.cookie = `session=${userCredential._tokenResponse.refreshToken}; Secure; HttpOnly; SameSite=Strict;`;

      // Log successful login to Firestore
      await logToFirestore({
        email: user.email,
        loginTime: new Date(),
        status: "success",
        method: "email_password",
      });
      logEvent(analytics, 'login', { method: 'email_password', email: user.email }); // Log to Analytics

      // Show a success toast
      toast.success("Login successful!");

      if (userRole === "admin") {
        const code = generateVerificationCode();
        setSentVerificationCode(code);
        setVerificationStep(true);
        sendVerificationCode(email, code);
      } else if (userRole === "pmanager") {
        navigate("/pm");
      }
    } catch (error) {
      console.error("Login error:", error);
      setFailedAttempts((prevAttempts) => prevAttempts + 1);
      alert(error.message);

      // Log failed login attempt to Firestore
      await logToFirestore({
        email,
        loginTime: new Date(),
        status: "failed",
        errorMessage: error.message,
      });
      logEvent(analytics, 'login_failed', { method: 'email_password', email, errorMessage: error.message }); // Log to Analytics

      if (failedAttempts + 1 >= 5) {
        setLockoutActive(true);
        setLockoutTime(30);
      }
    }
  };

  const handleGoogleLogin = async () => {
    const provider = new GoogleAuthProvider();

    try {
      const userCredential = await signInWithPopup(auth, provider);
      const user = userCredential.user;

      const userDoc = await getDoc(doc(db, "users", user.uid));
      const userData = userDoc.data();
      const userRole = userData?.role || "pmanager";

      // Log successful Google login to Firestore
      await logToFirestore({
        email: user.email,
        loginTime: new Date(),
        status: "success",
        method: "google",
      });
      logEvent(analytics, 'login', { method: 'google', email: user.email }); // Log to Analytics
      
      // Show a success toast
      toast.success("Google login successful!");

      if (userRole === "admin") {
        navigate("/admin-home");
      } else if (userRole === "pmanager") {
        navigate("/pm");
      }
    } catch (error) {
      console.error("Google login error:", error);
      alert(error.message);

      // Log failed Google login attempt to Firestore
      await logToFirestore({
        email: email || "unknown",
        loginTime: new Date(),
        status: "failed",
        errorMessage: error.message,
      });
      logEvent(analytics, 'login_failed', { method: 'google', email: email || "unknown", errorMessage: error.message }); // Log to Analytics
    }
  };

  const handleVerification = (e) => {
    e.preventDefault();
    if (verificationCode === sentVerificationCode) {
      navigate("/admin-home");
      logEvent(analytics, 'verification_success', { email }); // Log verification success
    } else {
      setVerificationError(true);
      logEvent(analytics, 'verification_failed', { email }); // Log verification failure
    }
  };

  return (
    <div className="background">
      <div className="login-container">
        <ToastContainer />
        {!verificationStep ? (
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

            <ReCAPTCHA
              sitekey={siteKey}
              onChange={handleCaptcha}
              onExpired={() => setCaptchaToken(null)}
            />
            {captchaError && <p style={{ color: "red" }}>Please complete the CAPTCHA verification.</p>}

            <button type="submit" className="submit" disabled={lockoutActive}>
              Sign in
            </button>
            <button type="button" className="submit" onClick={handleGoogleLogin}>
              Sign in with Google
            </button>
            {lockoutActive && (
              <p style={{ color: "red" }}>Too many failed attempts. Try again in {lockoutTime} seconds.</p>
            )}

            <p className="signup-link">
              No account? <a href="/signup">Sign up</a>
            </p>
          </form>
        ) : (
          <form className="form" onSubmit={handleVerification}>
            <p className="form-title">Enter Verification Code</p>
            <div className="input-container">
              <label>Verification Code:</label>
              <input
                type="text"
                placeholder="Enter verification code"
                value={verificationCode}
                onChange={(e) => setVerificationCode(e.target.value)}
                required
              />
            </div>
            {verificationError && <p style={{ color: "red" }}>Verification code is incorrect.</p>}
            <button type="submit" className="submit">
              Verify
            </button>
          </form>
        )}
      </div>
    </div>
  );
}

export default Login;
