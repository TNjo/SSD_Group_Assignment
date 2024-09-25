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
import Sites2 from "./pages/Sites/Sites2";
import AddSites from "./pages/AddSites/SiteForm";
import AddSites2 from "./pages/AddSites/SiteForm2";
import AdminSuppliers from "./pages/AdminSuppliers";
import AdminOrderDetails from "./pages/AdminOrderDetails";
import PendingOrders from "./pages/PendingOrders";
import Signup from "./pages/SignUp";
import Home from "./pages/Home";
import ProcurementManager from "./pages/StaffPM";
import OrderDetails from "./pages/StaffPM/OrderDetails";
import RiseInquiry from "./pages/RiseInquiry";
import InquireDetails from "./pages/InquireDetails";
import AdminApproveOrders from "./pages/AdminApprovedOrders";
import AdminRejectOrders from "./pages/AdminRejectOrders";
import AdminViewSupplierOrders from "./pages/AdminViewSupplierOrders";

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
          {/* <Sites2 />, */}
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
          {/* <AddSites2 />, */}
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
      path: "/pm",
      element: (
        <ProtectedRoute>
          <ProcurementManager />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/pm/:docId",
      element: (
        <ProtectedRoute>
          <OrderDetails />,
        </ProtectedRoute>
      ),
    },
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
    {
      path: "/admin-approvedOrders",
      element: (
        <ProtectedRoute>
          <AdminApproveOrders />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-rejectedOrders",
      element: (
        <ProtectedRoute>
          <AdminRejectOrders />,
        </ProtectedRoute>
      ),
    },
    {
      path: "/admin-ViewSupplierOrders/:orderId",
      element: (
        <ProtectedRoute>
          <AdminViewSupplierOrders />,
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
