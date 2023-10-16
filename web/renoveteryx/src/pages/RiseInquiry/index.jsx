import React, { useState, useEffect } from "react";
import {
  format,
  fromUnixTime,
  addDays,
  isAfter,
  differenceInDays,
} from "date-fns"; // Import differenceInDays
import { Link } from "react-router-dom";
import DashboardHeader from "../../components/DashboardHeader";
import {
  fetchOrders,
  deleteOrder,
} from "../../firebaseServices/firebaseServices";
import { calculateRange, sliceData } from "../../utils/table-pagination";
import "../styles.css";

function RiseInquiry() {
  const [search, setSearch] = useState("");
  const [orders, setOrders] = useState([]);
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState([]);

  useEffect(() => {
    fetchData();
  }, [page]);

  const calculateDueDate = (order) => {
    const orderDate = fromUnixTime(order.date.seconds);
    return addDays(orderDate, 5); // Calculate due date as order date + 5 days
  };

  const fetchData = async () => {
    try {
      const ordersData = await fetchOrders();

      const filteredOrders = ordersData.filter((order) => order.status === 2);

      // Filter orders based on the due date condition
      const currentDate = new Date();
      const filteredByDueDate = filteredOrders.filter((order) => {
        const dueDate = calculateDueDate(order);
        return isAfter(currentDate, dueDate);
      });

      setOrders(filteredByDueDate);

      setPagination(calculateRange(filteredByDueDate, 10));
      setOrders(sliceData(filteredByDueDate, page, 10));
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  };

  const handleSearch = (event) => {
    setSearch(event.target.value);
    if (event.target.value !== "") {
      let searchResults = orders.filter(
        (item) =>
          item.sitemanager.toLowerCase().includes(search.toLowerCase()) ||
          item.constructionSite.toLowerCase().includes(search.toLowerCase())
      );
      setOrders(searchResults);
    } else {
      handleChangePage(1);
      fetchData();
    }
  };

  const handleChangePage = (newPage) => {
    setPage(newPage);
    setOrders(sliceData(orders, newPage, 10));
  };

  const handleDeleteOrder = async (orderId) => {
    try {
      await deleteOrder(orderId);
      setOrders(orders.filter((order) => order.id !== orderId));
    } catch (error) {
      console.error("Error deleting order: ", error);
    }
  };

  return (
    <div className="dashboard-content">
      <DashboardHeader btnText="New Supplier" />

      <div className="dashboard-content-container">
        <div className="dashboard-content-header">
          <h2>Suppliers Overdue Orders</h2>
          <div className="dashboard-content-search">
            <input
              type="text"
              value={search}
              placeholder="Search.."
              className="dashboard-content-input"
              onChange={handleSearch}
            />
          </div>
        </div>
        <div className="dashboard-content">
          <div className="dashboard-content-container">
            {orders.length !== 0 ? (
              <table className="table table-striped">
                <thead>
                  <tr>
                    <th>Construction Site</th>
                    <th>Date</th>
                    <th>Supplier</th>
                    <th>Overdue Date</th>
                    <th>Items</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {orders.map((order) => (
                    <tr key={order.id}>
                      <td>{order.constructionSite}</td>
                      <td>
                        {format(
                          fromUnixTime(order.date.seconds),
                          "MM/dd/yyyy HH:mm:ss"
                        )}
                      </td>
                      <td>{order.supplier}</td>
                      <td style={{ color: "red" }}>
                        {differenceInDays(
                          new Date(),
                          fromUnixTime(order.date.seconds + 432000)
                        )}{" "}
                        days overdue
                      </td>
                      <td>
                        <ul>
                          {order.items.map((item, index) => (
                            <li key={index}>
                              {item.name}, Quantity: {item.quantity}, Price:
                              {item.price}
                            </li>
                          ))}
                        </ul>
                      </td>
                      <td>
                        <Link to={`/admin-InquiryDetails/${order.id}`}>
                          <button className="btn btn-warning btn-sm">
                            Inquire
                          </button>
                        </Link>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : (
              <div className="dashboard-content-footer">
                <span className="empty-table">No data</span>
              </div>
            )}

            <div className="dashboard-content-footer">
              {pagination.map((item, index) => (
                <span
                  key={index}
                  className={item === page ? "active-pagination" : "pagination"}
                  onClick={() => handleChangePage(item)}
                >
                  {item}
                </span>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default RiseInquiry;
