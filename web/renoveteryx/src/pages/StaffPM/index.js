import React, { useState, useEffect } from "react";
import { Link, useParams } from "react-router-dom";
import { calculateRange, sliceData } from "../../utils/table-pagination";
import { format, fromUnixTime } from "date-fns";
import { getStatusText } from "../../constants/getStatusText"
import { fetchAllOrderData, handleDeleteOrder } from "../../services/FirebaseServices";
import "../styles.css";

function ProcurementManager() {
  const [search, setSearch] = useState("");
  const [orders, setOrders] = useState([]);
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState([]);

  useEffect(() => {
    fetchData();
  }, [page, handleDeleteOrder]);

  const fetchData = async () => {
    const ordersData = await fetchAllOrderData();

    if (ordersData) {
      setOrders(ordersData);
      // console.log(ordersData)

      // Calculate pagination
      setPagination(calculateRange(ordersData, 10));
      setOrders(sliceData(ordersData, page, 10));
    }
  };

  // Search
  const handleSearch = (event) => {
    setSearch(event.target.value);
    if (event.target.value !== "") {
      let searchResults = orders.filter(
        (item) =>
          item.sitemanager.toLowerCase().includes(search.toLowerCase()) ||
          getStatusText(item.status).toLowerCase().includes(search.toLowerCase()) ||
          item.constructionSite.toLowerCase().includes(search.toLowerCase())
      );
      setOrders(searchResults);
    } else {
      handleChangePage(1);
      fetchData();
    }
  };

  // Change Page
  const handleChangePage = (newPage) => {
    setPage(newPage);
    setOrders(sliceData(orders, newPage, 10));
  };

  return (
    <div className="dashboard-content">
      <div className="dashboard-content-container">
        <div className="dashboard-content-header">
          <h2>Orders List</h2>
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

        {orders.length !== 0 ? (
          <table className="table table-striped">
            <thead>
              <tr>
                <th>#</th>
                <th>Construction Site</th>
                <th>Date</th>
                <th>Site Manager</th>
                <th>Status</th>
                <th>Supplier</th>
                <th>Total Price</th>
                <th>Order ID</th>
                <th>Items</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {orders.map((order, index) => (
                <tr key={order.id}>
                  <td>{index + 1}</td>
                  <td>{order.constructionSite}</td>
                  <td>{format(fromUnixTime(order.date.seconds), "MM/dd/yyyy HH:mm:ss")}</td>
                  <td>{order.sitemanager}</td>
                  <td>{getStatusText(order.status)}</td>
                  <td>{order.supplier}</td>
                  <td>{order.totalPrice}</td>
                  <td>{order.orderid}</td>
                  <td>
                    <ul>
                      {order.items.map((item, index) => (
                        <li key={index}>
                          {item.name} - Quantity: {item.quantity}
                        </li>
                      ))}
                    </ul>
                  </td>
                  <td>
                    <Link to={`/pm/${order.id}`}>
                      <button className="btn btn-primary">View</button>
                    </Link>
                    <button
                      className="btn btn-danger"
                      onClick={() => handleDeleteOrder(order.id)}
                    >
                      Delete
                    </button>
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
  );
}

export default ProcurementManager;