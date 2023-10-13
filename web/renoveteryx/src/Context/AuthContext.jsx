import React, { useEffect } from "react";
import { createContext, useContext, useState } from "react";
import { getAuth, onAuthStateChanged } from "firebase/auth";

export const Context = createContext();

function AuthContext({ children }) {
  const auth = getAuth();
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setLoading(false);
      setUser(currentUser);
    });

    return () => {
      unsubscribe(); // Cleanup subscription on unmount
    };
  }, [auth]);

  const values = {
    user,
    loading,
  };

  return (
    <Context.Provider value={values}>
      {" "}
      {/* Remove the double destructuring here */}
      {!loading && children}
    </Context.Provider>
  );
}

export default AuthContext;
