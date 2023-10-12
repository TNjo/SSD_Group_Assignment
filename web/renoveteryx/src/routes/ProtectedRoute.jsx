import React from "react";
import { Navigate } from "react-router-dom";
import { useContext } from "react";
import { Context } from "../Context/AuthContext";
import SideBar from "../components/Sidebar";
import sidebar_menu from "../constants/sidebar-menu";

function ProtectedRoute({ children }) {
  const { user } = useContext(Context);

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return (
    <div className="dashboard-container">
      <SideBar menu={sidebar_menu} />
      <div className="dashboard-body">{children}</div>
    </div>
  );
}

export default ProtectedRoute;
