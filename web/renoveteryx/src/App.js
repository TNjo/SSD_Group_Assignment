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
import Login from "./routes/Login";
import Signup from "./routes/signup";
import Home from "./routes/home";
import AuthContext from "./Context/AuthContext";
import ProtectedRoute from "./routes/ProtectedRoute";
import Viewitem from "./pages/ViewItem";

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
