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

      if (currentUser) {
        const email = currentUser.email;
        const role = email.endsWith("@gmail.com")
          ? "user"
          : email.endsWith("@example.com")
          ? "admin"
          : null;

        setUser({
          ...currentUser,
          role,
        });
      } else {
        setUser(null);
      }
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
    <Context.Provider value={values}>{!loading && children}</Context.Provider>
  );
}

export default AuthContext;
