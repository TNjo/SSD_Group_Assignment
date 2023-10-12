import React, { useEffect } from "react";
import { createContext, useContext, useState } from "react";
import { getAuth, onAuthStateChanged } from "firebase/auth";

export const Context = createContext();

function AuthContext({ children }) {
  const auth = getAuth();
  const [user, setUser] = useState();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setLoading(false);
      if (currentUser) {
        setUser(currentUser);
      } else {
        setUser(null);
      }
    });
    return () => {
      unsubscribe(); // No need for the "if (unsubscribe)" check
    };
  }, []);

  const values = {
    user: user,
    setUser: setUser,
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
