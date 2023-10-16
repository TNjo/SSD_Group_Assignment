import {
  getFirestore,
  collection,
  addDoc,
  getDocs,
  deleteDoc,
  doc,
} from "firebase/firestore";

import { app } from "../utils/fbconfig"; // Importing Firebase app configuration
const db = getFirestore(app); // Creating a Firestore database reference using the Firebase app configuration

// Function to fetch manager names from the "siteManagers" collection
export const fetchManagerNames = async () => {
  const siteManagersCollection = collection(db, "siteManagers");
  const siteManagersSnapshot = await getDocs(siteManagersCollection); // Fetching documents from the "siteManagers" collection
  const managerNames = [];
  siteManagersSnapshot.forEach((doc) => {
    const data = doc.data(); // Extracting the data from each document
    managerNames.push(data.managerName); // Adding the "managerName" to the result array
  });
  return managerNames; // Returning an array of manager names
};

// Function to add site data to the "sites" collection
export const addSiteData = async (siteData) => {
  try {
    const docRef = await addDoc(collection(db, "sites"), siteData); // Adding a new document to the "sites" collection
    return docRef.id; // Returning the ID of the newly added document
  } catch (error) {
    console.error("Error adding document: ", error);
    throw new Error("An error occurred while adding the site data");
  }
};

// Function to fetch supplier data from the "suppliers" collection
export const fetchSuppliersData = async () => {
  const suppliersCollection = collection(db, "suppliers");
  const suppliersSnapshot = await getDocs(suppliersCollection); // Fetching documents from the "suppliers" collection
  const suppliersData = suppliersSnapshot.docs.map((doc) => doc.data()); // Extracting data from each document
  return suppliersData; // Returning an array of supplier data
};

// Function to delete a supplier document from the "suppliers" collection
export const deleteSupplier = async (supplierId) => {
  const supplierRef = doc(db, "suppliers", supplierId); // Creating a reference to the supplier document
  await deleteDoc(supplierRef); // Deleting the supplier document
};

// Function to fetch order data from the "orders" collection
export async function fetchOrders() {
  const ordersCollection = collection(db, "orders");
  const ordersSnapshot = await getDocs(ordersCollection); // Fetching documents from the "orders" collection

  return ordersSnapshot.docs.map((doc) => {
    const data = doc.data(); // Extracting data from each document
    data.id = doc.id; // Adding the document ID to the data
    return data;
  });
}

// Function to delete an order document from the "orders" collection
export async function deleteOrder(orderId) {
  const orderDocRef = doc(db, "orders", orderId); // Creating a reference to the order document
  await deleteDoc(orderDocRef); // Deleting the order document
}

// Function to fetch site manager data from the "siteManagers" collection
export async function fetchSiteManagersData() {
  const siteManagersCollection = collection(db, "siteManagers");
  const siteManagersSnapshot = await getDocs(siteManagersCollection); // Fetching documents from the "siteManagers" collection
  const siteManagersData = siteManagersSnapshot.docs.map((doc) => doc.data()); // Extracting data from each document
  return siteManagersData; // Returning an array of site manager data
}

// Function to fetch site data from the "sites" collection
export async function fetchSiteData() {
  const sitesCollection = collection(db, "sites");
  const sitesSnapshot = await getDocs(sitesCollection); // Fetching documents from the "sites" collection
  const sitesData = sitesSnapshot.docs.map((doc) => doc.data()); // Extracting data from each document
  return sitesData; // Returning an array of site data
}
