import { useParams } from "react-router-dom";
import {
  getFirestore,
  collection,
  getDocs,
  where,
  query,
} from "firebase/firestore"; // Import Firestore related modules from Firebase.
import { useEffect, useState } from "react";
import DashboardHeader from "../../components/DashboardHeader";
import "./styles.css";

function Viewitem() {
  const { orderId } = useParams();
  const [order, setOrder] = useState(null);
  const collectionName = "orders";
  const fieldName = "orderID"; // Replace with the name of the field you want to query by
  const targetValue = orderId;
  const db = getFirestore();

  useEffect(() => {
    const fetchOrderDetails = async () => {
      const ordersCollection = collection(db, collectionName);
      const q = query(ordersCollection, where(fieldName, "==", targetValue));
      const ordersSnapshot = await getDocs(q);
      if (ordersSnapshot.empty) {
        // Handle the case where no matching order is found
        console.log("Order not found");
        return;
      }
      const orderData = ordersSnapshot.docs[0].data(); // Assuming there's only one matching order
      setOrder(orderData);
    };

    fetchOrderDetails();
  }, [db, collectionName, fieldName, targetValue]);

  return (
    <div className="dashboard-content">
      <DashboardHeader btnText="New Order" />
      <h2>View Order</h2>
      {order ? (
        <>
          <p>Order ID: {orderId}</p>
          <p>Date: {order.date}</p>
          <p>Site Manager: {order.siteManager}</p>
          <p>Construction Site: {order.constructionSite}</p>
          <h3>Item Details</h3>
          <table className="table">
            <thead>
              <tr>
                <th scope="col">ITEM</th>
                <th scope="col">QUANTITY</th>
                <th scope="col">UNIT PRICE</th>
                <th scope="col">TOTAL</th>
                <th scope="col">SUPPLIER</th>
                <th scope="col">ACTION</th>
              </tr>
            </thead>
            <tbody>
              {Object.entries(order.items).map(
                ([itemName, itemCount], index) => (
                  <tr key={index}>
                    <td>{itemName}</td>
                    <td>{itemCount}</td>
                    <td>1000</td>
                    <td>{itemCount * 1000}</td>
                    <td>
                      <div class="dropdown">
                        <button
                          class="btn btn-secondary dropdown-toggle"
                          type="button"
                          data-bs-toggle="dropdown"
                          aria-expanded="false"
                        >
                          Select Supplier
                        </button>
                        <ul class="dropdown-menu">
                          <li>
                            <a class="dropdown-item" href="#">
                              Action
                            </a>
                          </li>
                          <li>
                            <a class="dropdown-item" href="#">
                              Another action
                            </a>
                          </li>
                          <li>
                            <a class="dropdown-item" href="#">
                              Something else here
                            </a>
                          </li>
                        </ul>
                      </div>
                    </td>
                    <td>
                      <button type="button" className="btn btn-primary">
                        Send
                      </button>
                    </td>
                  </tr>
                )
              )}
            </tbody>
          </table>
        </>
      ) : (
        <p>Loading order details...</p>
      )}
    </div>
  );
}

export default Viewitem;
