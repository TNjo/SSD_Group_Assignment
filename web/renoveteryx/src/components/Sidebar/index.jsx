import React, { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import { getAuth, signOut, GoogleAuthProvider } from "firebase/auth";
import { getFirestore, collection, addDoc } from "firebase/firestore"; // Import Firestore methods
import SideBarItem from "./sidebar-item";

import "./styles.css";
import logo from "../../assets/images/white-logo.png";
import LogoutIcon from "../../assets/icons/logout.svg";
import { getAnalytics, logEvent } from "firebase/analytics"; // Import Firebase Analytics

function SideBar({ menu }) {
  const location = useLocation();
  const [active, setActive] = useState(1);
  
  const auth = getAuth();
  const db = getFirestore(); // Initialize Firestore
  const analytics = getAnalytics(); // Initialize Firebase Analytics

  async function handleLogout() {
    try {
      const user = auth.currentUser;
      await logLogoutEvent();
      await signOut(auth);
      console.log("User signed out");

      // If using Google, also sign out from Google
      const provider = new GoogleAuthProvider();
      await auth.signOut(provider); // Sign out from Google
      
      

      // Log the logout event to Firebase Analytics
      logEvent(analytics, 'user_logout', {
        email: user ? user.email : "unknown", // Handle case where user is null
        timestamp: new Date().toISOString(),
      });
      
    } catch (error) {
      console.error("Error during sign out: " + error);
    }
  }

  async function logLogoutEvent() {
    try {
      await addDoc(collection(db, "userActivityLogs"), {
        email: auth.currentUser.email, // Store the user's email
        event: "logout", // Event type
        timestamp: new Date(), // Current timestamp
      });
      console.log("Logout event logged successfully.");
    } catch (error) {
      console.error("Failed to log logout event:", error);
    }
  }

  useEffect(() => {
    menu.forEach((element) => {
      if (location.pathname === element.path) {
        setActive(element.id);
      }
    });
  }, [location.pathname]);

  const __navigate = (id) => {
    setActive(id);
  };

  return (
    <nav className="sidebar">
      <div className="sidebar-container">
        <div className="sidebar-logo-container">
          {/* <img src={logo} alt="logo" /> */}
          <h1 className="logo">RenoveteryX</h1>
        </div>

        <div className="sidebar-container">
          <div className="sidebar-items">
            {menu.map((item, index) => (
              <div key={index} onClick={() => __navigate(item.id)}>
                <SideBarItem active={item.id === active} item={item} />
              </div>
            ))}
          </div>

          <div className="sidebar-footer">
            <span className="sidebar-item-label" onClick={handleLogout}>
              Logout
              <img src={LogoutIcon} alt="Logout Icon" />
            </span>
          </div>
        </div>
      </div>
    </nav>
  );
}

export default SideBar;
