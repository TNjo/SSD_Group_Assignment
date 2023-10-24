import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import DashboardHeader from "../../components/DashboardHeader";
import { fetchOrderDetails } from "../../firebaseServices/firebaseServices";

function AdminViewSupplierOrders() {
  const { orderId } = useParams();
  const navigate = useNavigate();
  const [order, setOrder] = useState(null);

  useEffect(() => {
    const fetchOrder = async () => {
      const orderData = await fetchOrderDetails(orderId);
      if (orderData) {
        setOrder(orderData);
      }
    };

    fetchOrder();
  }, [orderId]);

  if (!order) {
    return <div>Loading...</div>;
  }

  return (
    <div className="dashboard-content">
      <DashboardHeader btnText="New Supplier" />
      <div className="dashboard-content-container">
        <h2>Order Details</h2>
        <p>Construction Site: {order.constructionSite}</p>
        <p>Date: {order.date.toDate().toLocaleString()}</p>
        <p>Site Manager: {order.sitemanager}</p>
        <p>Supplier: {order.supplier}</p>
        <p>Total Price: {order.totalPrice} </p>

        <h3>Items</h3>
        {order.items.map((item, index) => (
          <div key={index} className="order-item">
            <p>Item Name: {item.name}</p>
            <p>Quantity: {item.quantity}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default AdminViewSupplierOrders;
