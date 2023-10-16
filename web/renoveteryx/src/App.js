import React from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import { ToastContextProvider } from "../src/Context/ToastContext";
import SideBar from "./components/Sidebar";
import sidebar_menu from "./constants/sidebar-menu";
import firebase from "firebase/app";
import "firebase/auth";
import "./App.css";
import Orders from "./pages/StaffPM";
import Login from "./pages/Login/Login";
import AuthContext from "./Context/AuthContext";
import ProtectedRoute from "./routes/ProtectedRoute";
import AdminHome from "./pages/AdminHome";
import MyOrders from "./pages/MyOrders";
import SiteManagers from "./pages/SiteManagers";
import Sites from "./pages/Sites";
import AddSites from "./pages/AddSites";
import AdminSuppliers from "./pages/AdminSuppliers";
import AdminOrderDetails from "./pages/AdminOrderDetails";
import PendingOrders from "./pages/PendingOrders";
import Signup from "./pages/SignUp";
import Home from "./pages/Home";
import ProcurementManager from "./pages/StaffPM";
import OrderDetails from "./pages/StaffPM/OrderDetails";
import RiseInquiry from "./pages/RiseInquiry";
import InquireDetails from "./pages/InquireDetails";

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
      path: "/admin-pendingOrders",
      element: (
        <ProtectedRoute>
          <PendingOrders />,
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
      path: "/admin-Suppliers",
      element: (
        <ProtectedRoute>
          <AdminSuppliers />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-ViewOrders/:orderId",
      element: (
        <ProtectedRoute>
          <AdminOrderDetails />,
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
    ,
    {
      path: "/pm",
      element: <ProcurementManager />,
    },
    ,
    {
      path: "/pm/:docId",
      element: <OrderDetails />,
    },
    {
      path: "/admin-Inquiry",
      element: (
        <ProtectedRoute>
          <RiseInquiry />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-InquiryDetails/:orderId",
      element: (
        <ProtectedRoute>
          <InquireDetails />,
        </ProtectedRoute>
      ),
    },
  ]);
  return (
    <AuthContext>
      <ToastContextProvider>
        <RouterProvider router={router}></RouterProvider>
      </ToastContextProvider>
    </AuthContext>
  );
}

export default App;
