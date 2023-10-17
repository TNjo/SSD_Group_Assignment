import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { getFirestore, doc, getDoc, updateDoc } from "firebase/firestore";
import { toast } from "react-toastify";
import DashboardHeader from "../../components/DashboardHeader";
import { app } from "../../utils/fbconfig";

function InquireDetails() {
  const { orderId } = useParams();
  const navigate = useNavigate();
  const [order, setOrder] = useState(null);
  const [orderComment, setOrderComment] = useState("");

  const db = getFirestore(app);

  useEffect(() => {
    const orderRef = doc(db, "orders", orderId);

    const fetchOrder = async () => {
      const orderSnapshot = await getDoc(orderRef);

      if (orderSnapshot.exists()) {
        setOrder(orderSnapshot.data());
      } else {
        console.log("Order not found");
      }
    };

    fetchOrder();
  }, [orderId]);

  if (!order) {
    return <div>Loading...</div>;
  }

  const handleCommentChange = (comment) => {
    setOrderComment(comment);
  };

  const handleApprove = async () => {
    try {
      const db = getFirestore();
      const orderRef = doc(db, "orders", orderId);

      const updatedOrder = {
        status: 8,
        comment: orderComment,
      };

      await updateDoc(orderRef, updatedOrder);

      toast.success("Order sent successfully", { autoClose: 3000 });

      setTimeout(() => {
        navigate("/admin-myOrders");
      }, 3000);
    } catch (error) {
      console.error("Error approving order:", error);
    }
  };

  return (
    <div className="dashboard-content">
      <DashboardHeader btnText="New Supplier" />
      <div className="dashboard-content-container">
        <h2>Inquire Supplier</h2>
        <p>Construction Site: {order.constructionSite}</p>
        <p>Order Date: {order.date.toDate().toLocaleString()}</p>
        <p>Site Manager: {order.sitemanager}</p>
        <p>Supplier: {order.supplier}</p>

        <h3>Items</h3>
        <ul>
          {order.items.map((item, index) => (
            <li key={index}>
              <p>Item : {item.name}</p>
              <p>Quantity: {item.quantity}</p>
            </li>
          ))}
        </ul>

        <div className="form-group">
          <label htmlFor="comment">Add Comment</label>
          <textarea
            className="form-control"
            id="comment"
            rows="4"
            value={orderComment}
            onChange={(e) => handleCommentChange(e.target.value)}
          ></textarea>
        </div>

        <div className="text-center">
          <button onClick={handleApprove} className="btn btn-success">
            Send Inquire
          </button>
        </div>
      </div>
    </div>
  );
}

export default InquireDetails;
