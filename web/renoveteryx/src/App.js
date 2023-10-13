import React from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";

import SideBar from "./components/Sidebar";
import sidebar_menu from "./constants/sidebar-menu";
import firebase from "firebase/app";
import "firebase/auth";
import "./App.css";
import Orders from "./pages/Orders";
import Login from "./pages/Login/Login";
import Signup from "./routes/signup";
import Home from "./routes/home";
import AuthContext from "./Context/AuthContext";
import ProtectedRoute from "./routes/ProtectedRoute";
import Viewitem from "./pages/ViewItem";
import AdminHome from "./pages/AdminHome";
import AllOrders from "./pages/AllOrders";
import MyOrders from "./pages/MyOrders";
import SiteManagers from "./pages/SiteManagers";
import Sites from "./pages/Sites";
import AddSites from "./pages/AddSites";

function App() {
  const router = createBrowserRouter([
    {
      path: "/",
      element: (
        <ProtectedRoute>
          <Home />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/home",
      element: (
        <ProtectedRoute>
          <Home />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/orders",
      element: (
        <ProtectedRoute>
          <Orders />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/orders/:orderId",
      element: (
        <ProtectedRoute>
          <Viewitem />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-home",
      element: (
        <ProtectedRoute>
          <AdminHome />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-sites",
      element: (
        <ProtectedRoute>
          <Sites />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-siteManagers",
      element: (
        <ProtectedRoute>
          <SiteManagers />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-allOrders",
      element: (
        <ProtectedRoute>
          <AllOrders />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-myOrders",
      element: (
        <ProtectedRoute>
          <MyOrders />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-addSites",
      element: (
        <ProtectedRoute>
          <AddSites />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/login",
      element: <Login />,
    },
    {
      path: "/signup",
      element: <Signup />,
    },
    {
      path: "*",
      element: <div>404</div>,
    },
    {
      path: "/register/admin",
      element: <Signup />,
    },
  ]);
  return (
    <AuthContext>
      <RouterProvider router={router}></RouterProvider>
    </AuthContext>
  );
}

export default App;
