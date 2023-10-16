import React from "react";
import { Navigate } from "react-router-dom";
import { useContext } from "react";
import { Context } from "../Context/AuthContext";
import SideBar from "../components/Sidebar";
import sidebar_menu from "../constants/sidebar-menu";
import admin_sidebar_menu from "../constants/admin-sidebar-menu";

// Create a factory function to select the appropriate menu
function selectMenu(emailDomain) {
  if (emailDomain === "gmail.com") {
    return sidebar_menu; // Use the regular menu for gmail.com
  } else if (emailDomain === "example.com") {
    return admin_sidebar_menu; // Use the admin menu for example.com
  }
  return null; // Invalid email domain
}

function ProtectedRoute({ children }) {
  const { user } = useContext(Context);

  // Check if the user is authenticated and has an email
  if (!user || !user.email) {
    return <Navigate to="/login" replace />;
  }

  const emailDomain = user.email.split("@")[1]; // Get the domain part of the email
  const selectedMenu = selectMenu(emailDomain);

  if (!selectedMenu) {
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
