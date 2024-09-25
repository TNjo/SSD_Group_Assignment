import React, { useContext, useEffect, useState } from "react";
import { Navigate, useNavigate } from "react-router-dom";
import { Context } from "../Context/AuthContext";
import SideBar from "../components/Sidebar";
import sidebar_menu from "../constants/sidebar-menu";
import admin_sidebar_menu from "../constants/admin-sidebar-menu";
import { getFirestore, collection, query, where, getDocs } from "firebase/firestore"; // Firestore query methods
import { getAuth } from "firebase/auth"; // Firebase authentication methods

function ProtectedRoute({ children }) {
  const { user } = useContext(Context);
  const [userRole, setUserRole] = useState(null); // Store the role from Firestore
  const [loading, setLoading] = useState(true); // Loading state to handle async calls
  const db = getFirestore();
  const auth = getAuth();
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
      inactivityTimeout = setTimeout(() => {
        auth.signOut(); // Sign out the user after inactivity
        clearSessionCookies(); // Clear cookies after inactivity
        navigate("/login"); // Redirect to login page after sign out
      }, 15 * 60 * 1000); // 15 minutes of inactivity
    }

    // Clear session cookies and tokens
    function clearSessionCookies() {
      document.cookie = "session=; expires=Thu, 01 Jan 1988 00:00:00 UTC; path=/;";
      // Clear other cookies if needed
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
  }, [user, db, auth, navigate]);

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
