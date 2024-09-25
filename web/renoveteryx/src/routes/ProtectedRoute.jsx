import React, { useContext, useEffect, useState } from "react";
import { Navigate } from "react-router-dom";
import { Context } from "../Context/AuthContext";
import SideBar from "../components/Sidebar";
import sidebar_menu from "../constants/sidebar-menu";
import admin_sidebar_menu from "../constants/admin-sidebar-menu";
import { getFirestore, collection, query, where, getDocs } from "firebase/firestore"; // Import Firestore query methods

function ProtectedRoute({ children }) {
  const { user } = useContext(Context);
  const [userRole, setUserRole] = useState(null); // Store the role from Firestore
  const [loading, setLoading] = useState(true); // Loading state to handle async calls
  const db = getFirestore();

  useEffect(() => {
    // Fetch the user's role based on their email
    async function fetchUserRole() {
      if (user && user.email) {
        try {
          // Query Firestore collection where email matches the logged-in user email
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

    fetchUserRole();
  }, [user, db]);


  // Redirect to login if the user is not authenticated or no email exists
  if (!user || !user.email) {
    return <Navigate to="/login" replace />;
  }

  // Wait for the role to load from Firestore
  if (loading) {
    return <div>Loading...</div>; // Show a loading state while fetching user role
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
    return <Navigate to="/login" replace />; // Redirect if the role is invalid
  }

  return (
    <div className="dashboard-container">
      <SideBar menu={selectedMenu} />
      <div className="dashboard-body">{children}</div>
    </div>
  );
}
export default ProtectedRoute;
