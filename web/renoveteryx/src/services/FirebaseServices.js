import {
  getFirestore,
  doc,
  getDoc,
  collection,
  getDocs,
  addDoc,
  updateDoc,
  deleteDoc,
  query,
  where,
} from "firebase/firestore";
import { app } from "../utils/fbconfig";

// fetch specific order data
export const fetchOrderData = async (docId) => {
  const db = getFirestore(app);
  const orderRef = doc(db, "orders", docId);

  try {
    const orderSnapshot = await getDoc(orderRef);
    if (orderSnapshot.exists()) {
      const data = orderSnapshot.data();
      return data;
    } else {
      console.log("Order not found.");
      return null;
    }
  } catch (error) {
    console.error("Error fetching order data:", error);
    return null;
  }
};

//fetch supplier details
export const fetchSupplierData = async () => {
  try {
    const db = getFirestore(app);
    const suppliersCollection = collection(db, "suppliers");
    const suppliersSnapshot = await getDocs(suppliersCollection);

    const suppliers = suppliersSnapshot.docs.map((doc) => {
      const data = doc.data();
      data.id = doc.id;
      return data;
    });

    return suppliers;
  } catch (error) {
    console.error("Error fetching supplier data:", error);
    return null;
  }
};

//create new order
export const createOrderDocument = async (order) => {
  try {
    const db = getFirestore(app);
    const ordersCollection = collection(db, "orders");
    await addDoc(ordersCollection, order);
    console.log("Order document created in Firestore:", order);
  } catch (error) {
    console.error("Error creating order document:", error);
  }
};

// Delete Item inside the order items array
export const deleteItemFromOrder = async (itemNameToDelete, docId) => {
  const db = getFirestore(app);
  const orderDocRef = doc(db, "orders", docId);
  try {
    const orderSnapshot = await getDoc(orderDocRef);
    if (orderSnapshot.exists()) {
      const orderData = orderSnapshot.data();

      // Filter out the item to be deleted
      const updatedItems = orderData.items.filter(
        (item) => item.name !== itemNameToDelete
      );

      if (updatedItems.length === 0) {
        // If the items array is empty, delete the whole document
        await deleteDoc(orderDocRef);
        console.log(
          `Item '${itemNameToDelete}' deleted from the order, and the order is removed as it has no more items.`
        );
      } else {
        // Update the document with the modified items list
        await updateDoc(orderDocRef, {
          items: updatedItems,
        });
        console.log(`Item '${itemNameToDelete}' deleted from the order.`);
      }
    } else {
      console.log("Order document not found.");
    }
  } catch (error) {
    console.error("Error deleting item:", error);
  }
};

// Delete an order
export const handleDeleteOrder = async (docId) => {
  const db = getFirestore(app);
  try {
    const orderDocRef = doc(db, "orders", docId);
    await deleteDoc(orderDocRef);
  } catch (error) {
    console.error("Error deleting order: ", error);
  }
};

// Fetch data from Firestore
export const fetchAllOrderData = async () => {
  const db = getFirestore(app);
  const ordersCollection = collection(db, "orders");
  const ordersSnapshot = await getDocs(ordersCollection);

  const ordersData = ordersSnapshot.docs.map((doc) => {
    const data = doc.data();
    data.id = doc.id;
    return data;
  });

  return ordersData;
};

//fetch budget of the site according to the location
export const fetchSiteBudget = async (location) => {
  const db = getFirestore(app);
  const siteData = collection(db, "sites");

  // Create a query with a 'where' clause to filter by 'location'
  const q = query(siteData, where("location", "==", location));

  // Execute the query and get the first matching document
  const querySnapshot = await getDocs(q);
  const firstMatchingDoc = querySnapshot.docs[0];

  if (firstMatchingDoc) {
    // Extract the data from the first matching document
    const data = firstMatchingDoc.data();
    const firstLocation = data.location;
    const firstBudget = data.budget;
    return firstBudget;
  } else {
    return null; // No matching document found
  }
};

// Update the budget of a location by subtracting an amount
export const updateSiteBudget = async (location, amountToSubtract) => {
  const db = getFirestore(app);
  const siteData = collection(db, "sites");

  // Create a query with a 'where' clause to filter by 'location'
  const q = query(siteData, where("location", "==", location));

  // Execute the query and get the first matching document
  const querySnapshot = await getDocs(q);
  const firstMatchingDoc = querySnapshot.docs[0];

  if (firstMatchingDoc) {
    // Extract the data from the first matching document
    const data = firstMatchingDoc.data();
    const docId = firstMatchingDoc.id;

    // Calculate the updated budget
    const currentBudget = data.budget || 0;
    const updatedBudget = currentBudget - amountToSubtract;

    // Update the Firestore document with the new budget
    const docRef = doc(db, "sites", docId);
    await updateDoc(docRef, {
      budget: updatedBudget,
    });

    console.log(
      `Budget updated for location '${location}'. New budget: ${updatedBudget}`
    );
  } else {
    console.log("No matching site details found for the specified location.");
  }
};





