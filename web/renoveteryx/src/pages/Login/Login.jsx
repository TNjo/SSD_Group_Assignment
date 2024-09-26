// import React, { useState, useEffect } from "react";
// import { getAuth, signInWithEmailAndPassword } from "firebase/auth";
// import { getFirestore, doc, getDoc } from "firebase/firestore"; // Firestore import
// import { useNavigate } from "react-router-dom";
// import ReCAPTCHA from "react-google-recaptcha";
// import emailjs from "emailjs-com";
// import "./loginStyle.css";
// import { GoogleAuthProvider, signInWithPopup } from "firebase/auth";

 
// function Login() {
//   const [email, setEmail] = useState("");
//   const [password, setPassword] = useState("");
//   const [captchaToken, setCaptchaToken] = useState(null);
//   const [captchaError, setCaptchaError] = useState(false);
//   const [failedAttempts, setFailedAttempts] = useState(0);
//   const [lockoutTime, setLockoutTime] = useState(0);
//   const [lockoutActive, setLockoutActive] = useState(false);
//   const [verificationCode, setVerificationCode] = useState("");
//   const [sentVerificationCode, setSentVerificationCode] = useState(null);
//   const [verificationStep, setVerificationStep] = useState(false); // For 2-step verification
//   const [verificationError, setVerificationError] = useState(false);
 
//   const navigate = useNavigate();
//   const auth = getAuth();
//   const db = getFirestore();
 
//   useEffect(() => {
//     let timer;
//     if (lockoutActive && lockoutTime > 0) {
//       timer = setInterval(() => {
//         setLockoutTime((prevTime) => prevTime - 1);
//       }, 1000);
//     } else if (lockoutTime === 0) {
//       setLockoutActive(false);
//       setFailedAttempts(0);
//     }
//     return () => clearInterval(timer);
//   }, [lockoutActive, lockoutTime]);
 
//   const handleCaptcha = (token) => {
//     setCaptchaToken(token);
//     setCaptchaError(false);
//   };
 
//   // Function to generate a random verification code
//   const generateVerificationCode = () => {
//     return Math.floor(100000 + Math.random() * 900000).toString(); // Generates a 6-digit code
//   };
 
//   // Function to send the verification code via EmailJS
//   const sendVerificationCode = (email, code) => {
//     const templateParams = {
//       to_email: email,
//       verificationCode: code,
//     };
 
//     emailjs
//       .send(
//         "service_6fiu4br", // Replace with your EmailJS Service ID
//         "template_9z1ykku", // Replace with your EmailJS Template ID
//         templateParams,
//         "lQRpj0D8qILcylxwq" // Replace with your EmailJS User ID
//       )
//       .then(
//         (response) => {
//           console.log("Verification code sent successfully", response.status, response.text);
//         },
//         (err) => {
//           console.error("Failed to send verification code:", err);
//         }
//       );
//   };
 
//   const handleLogin = async (e) => {
//     e.preventDefault();
 
//     if (!captchaToken) {
//       setCaptchaError(true);
//       return;
//     }
 
//     if (lockoutActive) {
//       alert(`Account locked. Please wait ${lockoutTime} seconds.`);
//       return;
//     }
 
//     try {
//        // Set persistence to session-based (The user will stay signed in only during the session)
//        await auth.setPersistence(getAuth().Auth.Persistence.SESSION);

//       const userCredential = await signInWithEmailAndPassword(auth, email, password);
//       const user = userCredential.user;
 
//       // Fetch the role from Firestore
//       const userDoc = await getDoc(doc(db, "users", user.uid));
//       const userData = userDoc.data();
//       const userRole = userData?.role || "pmanager";

//       // Set session cookies (Optional if using Firebase managed session cookies)
//       document.cookie = `session=${userCredential._tokenResponse.refreshToken}; Secure; HttpOnly; SameSite=Strict;`;
 
//       // If user is an admin, initiate 2-step verification
//       if (userRole === "admin") {
//         const code = generateVerificationCode();
//         setSentVerificationCode(code);
//         setVerificationStep(true); // Move to verification step
//         sendVerificationCode(email, code); // Send the verification code to the admin's email
//       } else if (userRole === "pmanager") {
//         navigate("/pm");
//       }
//     } catch (error) {
//       console.error("Login error:", error);
//       setFailedAttempts((prevAttempts) => prevAttempts + 1);
//       alert(error.message);
 
//       if (failedAttempts + 1 >= 5) {
//         setLockoutActive(true);
//         setLockoutTime(30); // Lockout for 30 seconds
//       }
//     }
//   };
 
//   const handleVerification = (e) => {
//     e.preventDefault();
//     if (verificationCode === sentVerificationCode) {
//       navigate("/admin-home"); // Successful verification for admin
//     } else {
//       setVerificationError(true);
//     }
//   };
 
//   return (
//     <div className="background">
//       <div className="login-container">
//         {!verificationStep ? (
//           <form className="form" onSubmit={handleLogin}>
//             <p className="form-title">Login In To Your Account</p>
//             <div className="input-container">
//               <label>Email:</label>
//               <input
//                 type="email"
//                 placeholder="Enter email"
//                 value={email}
//                 onChange={(e) => setEmail(e.target.value)}
//                 required
//               />
//             </div>
//             <div className="input-container">
//               <label>Password:</label>
//               <input
//                 type="password"
//                 placeholder="Enter password"
//                 value={password}
//                 onChange={(e) => setPassword(e.target.value)}
//                 required
//               />
//             </div>
 
//             <ReCAPTCHA
//               sitekey="6Leq200qAAAAAC8J1uMY2HyC51LMwHZU4lOGhJSZ"
//               onChange={handleCaptcha}
//               onExpired={() => setCaptchaToken(null)}
//             />
//             {captchaError && <p style={{ color: "red" }}>Please complete the CAPTCHA verification.</p>}
 
//             <button type="submit" className="submit" disabled={lockoutActive}>
//               Sign in
//             </button>
//             {lockoutActive && (
//               <p style={{ color: "red" }}>Too many failed attempts. Try again in {lockoutTime} seconds.</p>
//             )}
 
//             <p className="signup-link">
//               No account? <a href="/signup">Sign up</a>
//             </p>
//           </form>
//         ) : (
//           <form className="form" onSubmit={handleVerification}>
//             <p className="form-title">Enter Verification Code</p>
//             <div className="input-container">
//               <label>Verification Code:</label>
//               <input
//                 type="text"
//                 placeholder="Enter verification code"
//                 value={verificationCode}
//                 onChange={(e) => setVerificationCode(e.target.value)}
//                 required
//               />
//             </div>
//             {verificationError && <p style={{ color: "red" }}>Invalid verification code. Try again.</p>}
//             <button type="submit" className="submit">
//               Verify
//             </button>
//           </form>
//         )}
//       </div>
//     </div>
//   );
// }
 
// export default Login;


import React, { useState, useEffect } from "react";
import { getAuth, signInWithEmailAndPassword, GoogleAuthProvider, signInWithPopup } from "firebase/auth";
import { getFirestore, doc, getDoc } from "firebase/firestore";
import { useNavigate } from "react-router-dom";
import ReCAPTCHA from "react-google-recaptcha";
import emailjs from "emailjs-com";
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
        },
        (err) => {
          console.error("Failed to send verification code:", err);
        }
      );
  };

  const handleLogin = async (e) => {
    e.preventDefault();

    if (!captchaToken) {
      setCaptchaError(true);
      return;
    }

    if (lockoutActive) {
      alert(`Account locked. Please wait ${lockoutTime} seconds.`);
      return;
    }

    try {
      //await auth.setPersistence(getAuth().Auth.Persistence.SESSION);

      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const user = userCredential.user;

      const userDoc = await getDoc(doc(db, "users", user.uid));
      const userData = userDoc.data();
      const userRole = userData?.role || "pmanager";

      document.cookie = `session=${userCredential._tokenResponse.refreshToken}; Secure; HttpOnly; SameSite=Strict;`;

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

      if (userRole === "admin") {
        navigate("/admin-home");
      } else if (userRole === "pmanager") {
        navigate("/pm");
      }
    } catch (error) {
      console.error("Google login error:", error);
      alert(error.message);
    }
  };

  const handleVerification = (e) => {
    e.preventDefault();
    if (verificationCode === sentVerificationCode) {
      navigate("/admin-home");
    } else {
      setVerificationError(true);
    }
  };

  return (
    <div className="background">
      <div className="login-container">
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
              sitekey="6Leq200qAAAAAC8J1uMY2HyC51LMwHZU4lOGhJSZ"
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
            {verificationError && <p style={{ color: "red" }}>Invalid verification code. Try again.</p>}
            <button type="submit" className="submit">
              Verify
            </button>
          </form>
        )}

        {/* Add Google Login Button */}
        <div className="google-login">
          <button onClick={handleGoogleLogin} className="google-login-button">
            Sign in with Google
          </button>
        </div>
      </div>
    </div>
  );
}

export default Login;
