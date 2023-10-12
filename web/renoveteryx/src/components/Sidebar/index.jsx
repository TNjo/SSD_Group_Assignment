import React, { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import { getAuth, signOut } from "firebase/auth";
import SideBarItem from "./sidebar-item";

import "./styles.css";
import logo from "../../assets/images/white-logo.png";
import LogoutIcon from "../../assets/icons/logout.svg";

function SideBar({ menu }) {
  const location = useLocation();

  const [active, setActive] = useState(1);

  const auth = getAuth();
  async function handleLogout() {
    await signOut(auth)
      .then(() => {
        console.log("User signed out");
      })
      .catch((error) => {
        console.error("Error: " + error);
      });
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
          {/* <img
                        src={logo}
                        alt="logo" /> */}
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
            </span>
            <img
              src={LogoutIcon}
              alt="icon-logout"
              className="sidebar-item-icon"
              onClick={handleLogout}
            />
          </div>
        </div>
      </div>
    </nav>
  );
}

export default SideBar;
