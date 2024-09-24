import React, { useContext, useEffect } from "react";
import { Navigate } from "react-router-dom";
import { Context } from "../Context/AuthContext";
import SideBar from "../components/Sidebar";
import sidebar_menu from "../constants/sidebar-menu";
import admin_sidebar_menu from "../constants/admin-sidebar-menu";
import { getAuth } from "firebase/auth";
 
// Factory function to select the appropriate menu based on email domain
function selectMenu(emailDomain) {
  if (emailDomain === "gmail.com") {
    return sidebar_menu; // Regular menu for gmail.com
  } else if (emailDomain === "example.com") {
    return admin_sidebar_menu; // Admin menu for example.com
  }
  return null; // Invalid email domain
}
 
function ProtectedRoute({ children }) {
  const { user } = useContext(Context);
  const auth = getAuth();
  let inactivityTimeout;
 
  // Check if the user is authenticated and has an email
  if (!user || !user.email) {
    return <Navigate to="/login" replace />;
  }
 
  const emailDomain = user.email.split("@")[1]; // Get the domain part of the email
  const selectedMenu = selectMenu(emailDomain);
 
  if (!selectedMenu) {
    return <Navigate to="/login" replace />;
  }
 
  // Function to reset the inactivity timeout
  function resetTimeout() {
    clearTimeout(inactivityTimeout);
    inactivityTimeout = setTimeout(() => {
      auth.signOut(); // Sign out the user after inactivity
      console.log("User signed out due to inactivity.");
    }, 15 * 60 * 1000); // 15 minutes of inactivity
  }
 
  // Set up event listeners for user activity on mount
  useEffect(() => {
    document.addEventListener("mousemove", resetTimeout);
    document.addEventListener("keypress", resetTimeout);
 
    // Initialize the inactivity timeout when the component mounts
    resetTimeout();
 
    // Clean up event listeners and timeout on unmount
    return () => {
      document.removeEventListener("mousemove", resetTimeout);
      document.removeEventListener("keypress", resetTimeout);
      clearTimeout(inactivityTimeout);
    };
  }, []);
 
  return (
    <div className="dashboard-container">
      <SideBar menu={selectedMenu} />
      <div className="dashboard-body">{children}</div>
    </div>
  );
}
 
export default ProtectedRoute;