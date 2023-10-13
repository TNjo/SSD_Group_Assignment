import React, { useState, useEffect } from "react";
import DashboardHeader from "../../components/DashboardHeader";
import { getFirestore, collection, getDocs } from "firebase/firestore"; // Import Firestore related modules from Firebase.
import { Link } from "react-router-dom";
import all_orders from "../../constants/orders";
import { calculateRange, sliceData } from "../../utils/table-pagination";

import "../styles.css";
function Orders() {
  const [search, setSearch] = useState("");
  const [orders, setOrders] = useState([]);
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState([]);
  const db = getFirestore();

  const fetchData = async () => {
    const ordersCollection = collection(db, "orders"); // Replace "orders" with the name of your Firestore collection.
    const ordersSnapshot = await getDocs(ordersCollection);
    const ordersData = ordersSnapshot.docs.map((doc) => doc.data());
    // Set the orders data to the state
    setOrders(ordersData);
    console.log(ordersData);
    // Calculate pagination
    setPagination(calculateRange(ordersData, 5));
    setOrders(sliceData(ordersData, page, 5));
  };

  useEffect(() => {
    fetchData();
  }, [page]);

  // Search
  const __handleSearch = (event) => {
    setSearch(event.target.value);
    if (event.target.value !== "") {
      let search_results = orders.filter(
        (item) =>
          item.siteManager.toLowerCase().includes(search.toLowerCase()) ||
          item.constructionSite.toLowerCase().includes(search.toLowerCase())
      );
      setOrders(search_results);
    } else {
      __handleChangePage(1);
    }
  };

  // Change Page
  const __handleChangePage = (new_page) => {
    setPage(new_page);
    setOrders(sliceData(all_orders, new_page, 5));
  };

  function calculateItemCount(items) {
    if (items) {
      // Calculate the count of items present in the items object
      const itemKeys = Object.keys(items);
      return itemKeys.length;
    } else {
      fetchData(); // Return 0 if items is undefined or null
    }
  }

  return (
    <div className="dashboard-content">
      <DashboardHeader btnText="New Order" />

      {/* <div className="dashboard-content-container">
        <div className="dashboard-content-header">
          <h2>Orders List</h2>
          <div className="dashboard-content-search">
            <input
              type="text"
              value={search}
              placeholder="Search.."
              className="dashboard-content-input"
              onChange={(e) => __handleSearch(e)}
            />
          </div>
        </div>

        <table className="table">
          <thead>
            <th scope="col">ID</th>
            <th scope="col">DATE</th>
            <th scope="col">SITE MANAGER</th>
            <th scope="col">CONSTRUCTION SITE</th>
            <th scope="col">ITEM COUNT</th>
            <th scope="col">DESCISSION</th>
          </thead>

          {orders.length !== 0 ? (
            <tbody>
              {orders.map((order, index) => (
                <tr key={index}>
                  <td>{order.orderID}</td>
                  <td>{order.date}</td>
                  <td>
                    <div>{order.siteManager}</div>
                  </td>
                  <td>{order.constructionSite}</td>
                  <td>{calculateItemCount(order.items)}</td>
                  <td>
                    <div>
                      <Link
                        to={`/orders/${order.orderID}`}
                        className="dashboard-approve-btn"
                      >
                        View
                      </Link>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          ) : null}
        </table>

        {orders.length !== 0 ? (
          <div className="dashboard-content-footer">
            {pagination.map((item, index) => (
              <span
                key={index}
                className={item === page ? "active-pagination" : "pagination"}
                onClick={() => __handleChangePage(item)}
              >
                {item}
              </span>
            ))}
          </div>
        ) : (
          <div className="dashboard-content-footer">
            <span className="empty-table">No data</span>
          </div>
        )}
      </div> */}
    </div>
  );
}

export default Orders;
