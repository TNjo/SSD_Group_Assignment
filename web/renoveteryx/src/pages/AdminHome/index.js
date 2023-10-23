import React from "react";
import "./AdminHome.css"; // Import a CSS file for styling

function AdminHome() {
  return (
    <div className="admin-home-container">
      <div className="button-container">
        <button className="big-button">Sites</button>
        <button className="big-button">Site Managers</button>
        <button className="big-button">Suppliers</button>
        <button className="big-button">Pending Orders</button>
        <button className="big-button">My Orders</button>
        <button className="big-button">Raise Inquiry</button>
      </div>
    </div>
  );
}

export default AdminHome;
