import React, { useContext, useEffect, useState } from "react";
import { Navigate, useNavigate } from "react-router-dom";
import { Context } from "../Context/AuthContext";
import SideBar from "../components/Sidebar";
import sidebar_menu from "../constants/sidebar-menu";
import admin_sidebar_menu from "../constants/admin-sidebar-menu";
import { getFirestore, collection, query, where, getDocs, addDoc } from "firebase/firestore"; // Firestore methods
import { getAuth } from "firebase/auth"; // Firebase authentication methods
import { getAnalytics, logEvent } from "firebase/analytics"; // Firebase Analytics

function ProtectedRoute({ children }) {
  const { user } = useContext(Context);
  const [userRole, setUserRole] = useState(null); // Store the role from Firestore
  const [loading, setLoading] = useState(true); // Loading state to handle async calls
  const db = getFirestore();
  const auth = getAuth();
  const analytics = getAnalytics(); // Initialize Firebase Analytics
  const navigate = useNavigate(); // To redirect the user after logout
  let inactivityTimeout; // Timeout for inactivity tracking

  useEffect(() => {
    // Fetch the user's role based on their email
    async function fetchUserRole() {
      if (user && user.email) {
        try {
          const q = query(collection(db, "users"), where("email", "==", user.email));
          const querySnapshot = await getDocs(q);

          if (!querySnapshot.empty) {
            const userData = querySnapshot.docs[0].data(); // Get the first matching document
            setUserRole(userData.role); // Set the user's role
          } else {
            console.error("No user found with this email");
            setUserRole(null); // Handle if no user document is found
          }
        } catch (error) {
          console.error("Error fetching user role:", error);
          setUserRole(null); // Handle any errors
        } finally {
          setLoading(false); // Set loading to false once fetching is done
        }
      } else {
        setLoading(false); // Set loading to false if no user is logged in
      }
    }

    // Inactivity Timeout Setup
    function resetTimeout() {
      clearTimeout(inactivityTimeout);
      inactivityTimeout = setTimeout(async () => {
        await logInactivity(); // Log the inactivity event to Firestore and Analytics
        auth.signOut(); // Sign out the user after inactivity
        clearSessionCookies(); // Clear cookies after inactivity
        navigate("/login"); // Redirect to login page after sign out
      }, 15 * 60 * 1000); // 15 minutes of inactivity
    }

    // Logging inactivity timeout to Firestore and Firebase Analytics
    async function logInactivity() {
      try {
        // Log the inactivity event to Firestore
        await addDoc(collection(db, "userActivityLogs"), {
          email: user.email,
          event: "inactivity_timeout",
          timestamp: new Date(),
        });

        // Log the event to Firebase Analytics
        logEvent(analytics, 'inactivity_timeout', {
          email: user.email,
          time: new Date().toISOString(),
        });

        console.log("Inactivity timeout logged successfully.");
      } catch (error) {
        console.error("Failed to log inactivity:", error);
      }
    }

    // Clear session cookies and tokens
    function clearSessionCookies() {
      document.cookie = "session=; expires=Thu, 01 Jan 1988 00:00:00 UTC; path=/;";
    }

    // Attach event listeners for user activity
    document.addEventListener("mousemove", resetTimeout);
    document.addEventListener("keypress", resetTimeout);

    // Initialize the timer
    resetTimeout();

    fetchUserRole();

    // Cleanup event listeners on component unmount
    return () => {
      document.removeEventListener("mousemove", resetTimeout);
      document.removeEventListener("keypress", resetTimeout);
      clearTimeout(inactivityTimeout); // Clear any remaining timeout
    };
  }, [user, db, auth, analytics, navigate]);

  // Redirect to login if the user is not authenticated or no email exists
  if (!user || !user.email) {
    return <Navigate to="/login" replace />;
  }

  // Wait for the role to load from Firestore
  if (loading) {
    return <div>Loading...</div>;
  }

  // If userRole is null or invalid, redirect to login
  if (!userRole) {
    return <Navigate to="/login" replace />;
  }

  // Select the appropriate menu based on the user's role
  let selectedMenu;
  if (userRole === "admin") {
    selectedMenu = admin_sidebar_menu;
  } else if (userRole === "pmanager") {
    selectedMenu = sidebar_menu; // Use the pmanager menu for Procurement Managers
  } else {
    return <Navigate to="/login" replace />;
  }

  return (
    <div className="dashboard-container">
      <SideBar menu={selectedMenu} />
      <div className="dashboard-body">{children}</div>
    </div>
  );
}

export default ProtectedRoute;
