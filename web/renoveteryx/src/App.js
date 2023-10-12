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

import "./App.css";
import Orders from "./pages/Orders";
import Login from "./routes/Login";
import Signup from "./routes/signup";
import Home from "./routes/home";
import AuthContext from "./Context/AuthContext";
import ProtectedRoute from "./routes/ProtectedRoute";

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
  ]);
  return (
    // <Router>
    //   <div className="dashboard-container">
    //     <SideBar menu={sidebar_menu} />

    //     <div className="dashboard-body">
    //       <Routes>
    //         <Route path="*" element={<div></div>} />
    //         <Route exact path="/dash" element={<div></div>} />
    //         <Route exact path="/orders" element={<Orders />} />
    //         <Route exact path="/locations" element={<div></div>} />
    //         <Route exact path="/profile" element={<div></div>} />
    //       </Routes>
    //     </div>
    //   </div>
    // </Router>
    <AuthContext>
      <RouterProvider router={router}></RouterProvider>
    </AuthContext>
  );
}

export default App;
