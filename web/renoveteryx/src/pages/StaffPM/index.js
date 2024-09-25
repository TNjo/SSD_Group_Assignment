import React, { useState, useEffect, useContext } from "react";
import { Link, useParams } from "react-router-dom";
import { calculateRange, sliceData } from "../../utils/table-pagination";
import { format, fromUnixTime } from "date-fns";
import { getStatusText } from "../../constants/getStatusText";
import {
  fetchAllOrderData,
  handleDeleteOrder,
} from "../../services/FirebaseServices";
import "../styles.css";
import ToastContext from "../../Context/ToastContext";
import DOMPurify from "dompurify";

function ProcurementManager() {
  const { toast } = useContext(ToastContext);
  const [search, setSearch] = useState("");
  const [orders, setOrders] = useState([]);
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState([]);

  useEffect(() => {
    fetchData();
  }, [page]);

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

  const handleSearch = (event) => {
    const sanitizedInput = DOMPurify.sanitize(event.target.value);
    setSearch(sanitizedInput);

    if (sanitizedInput !== "") {
      let searchResults = orders.filter(
        (item) =>
          item.sitemanager
            .toLowerCase()
            .includes(sanitizedInput.toLowerCase()) ||
          getStatusText(item.status)
            .toLowerCase()
            .includes(sanitizedInput.toLowerCase()) ||
          item.constructionSite
            .toLowerCase()
            .includes(sanitizedInput.toLowerCase())
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

  const deleteOrder = async (orderId) => {
    try {
      await handleDeleteOrder(orderId);
      const updatedOrders = orders.filter((order) => order.id !== orderId);
      setOrders(updatedOrders);
      toast.success("Order Deleted Successfully");
    } catch (error) {
      toast.error("Error deleting order:", error);
      console.error("Error deleting order:", error);
    }
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
                  <td
                    dangerouslySetInnerHTML={{
                      __html: DOMPurify.sanitize(order.constructionSite),
                    }}
                  />
                  <td>
                    {format(
                      fromUnixTime(order.date.seconds),
                      "MM/dd/yyyy HH:mm:ss"
                    )}
                  </td>
                  <td
                    dangerouslySetInnerHTML={{
                      __html: DOMPurify.sanitize(order.sitemanager),
                    }}
                  />
                  <td>{getStatusText(order.status)}</td>
                  <td
                    dangerouslySetInnerHTML={{
                      __html: DOMPurify.sanitize(order.supplier),
                    }}
                  />
                  <td>{order.totalPrice}</td>
                  <td>{order.orderid}</td>
                  <td>
                    <ul>
                      {order.items.map((item, index) => (
                        <li key={index}>
                          {DOMPurify.sanitize(item.name)} - Quantity:{" "}
                          {item.quantity}
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
                      onClick={() => deleteOrder(order.id)}
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
