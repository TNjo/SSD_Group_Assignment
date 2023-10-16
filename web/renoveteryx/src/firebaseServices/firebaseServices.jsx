import {
  getFirestore,
  collection,
  addDoc,
  getDocs,
  deleteDoc,
  doc,
} from "firebase/firestore";
import {app} from "../utils/fbconfig"
const db = getFirestore(app);

export const fetchManagerNames = async () => {
  const siteManagersCollection = collection(db, "siteManagers");
  const siteManagersSnapshot = await getDocs(siteManagersCollection);
  const managerNames = [];
  siteManagersSnapshot.forEach((doc) => {
    const data = doc.data();
    managerNames.push(data.managerName);
  });
  return managerNames;
};

export const addSiteData = async (siteData) => {
  try {
    const docRef = await addDoc(collection(db, "sites"), siteData);
    return docRef.id;
  } catch (error) {
    console.error("Error adding document: ", error);
    throw new Error("An error occurred while adding the site data");
  }
};

export const fetchSuppliersData = async () => {
  const suppliersCollection = collection(db, "suppliers");
  const suppliersSnapshot = await getDocs(suppliersCollection);
  const suppliersData = suppliersSnapshot.docs.map((doc) => doc.data());
  return suppliersData;
};

export const deleteSupplier = async (supplierId) => {
  const supplierRef = doc(db, "suppliers", supplierId);
  await deleteDoc(supplierRef);
};

export async function fetchOrders() {
  const ordersCollection = collection(db, "orders");
  const ordersSnapshot = await getDocs(ordersCollection);

  return ordersSnapshot.docs.map((doc) => {
    const data = doc.data();
    data.id = doc.id;
    return data;
  });
}

// Function to delete an order
export async function deleteOrder(orderId) {
  const orderDocRef = doc(db, "orders", orderId);
  await deleteDoc(orderDocRef);
}

export async function fetchSiteManagersData() {
  const siteManagersCollection = collection(db, "siteManagers");
  const siteManagersSnapshot = await getDocs(siteManagersCollection);
  const siteManagersData = siteManagersSnapshot.docs.map((doc) => doc.data());
  return siteManagersData;
}

export async function fetchSiteData() {
  const sitesCollection = collection(db, "sites");
  const sitesSnapshot = await getDocs(sitesCollection);
  const sitesData = sitesSnapshot.docs.map((doc) => doc.data());
  return sitesData;
}
