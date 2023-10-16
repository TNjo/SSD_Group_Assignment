import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import {
  getFirestore,
  doc,
  getDoc,
  collection,
  getDocs,
  updateDoc,
} from "firebase/firestore";
import { toast } from "react-toastify";
import DashboardHeader from "../../components/DashboardHeader";
 import { app } from "../../utils/fbconfig";

function AdminOrderDetails() {
  const { orderId } = useParams();
  const navigate = useNavigate();
  const [order, setOrder] = useState(null);
  const [suppliers, setSuppliers] = useState([]);
  const [orderComment, setOrderComment] = useState("");
  const [selectedSuppliers, setSelectedSuppliers] = useState({});
  const [unitPrices, setUnitPrices] = useState({});
  const [selectedSupplierEmails, setSelectedSupplierEmails] = useState({});
 
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

    const suppliersCollection = collection(db, "suppliers");

    const fetchSuppliers = async () => {
      const suppliersSnapshot = await getDocs(suppliersCollection);
      const supplierData = [];
      const supplierEmails = {};

      suppliersSnapshot.forEach((doc) => {
        const supplier = { id: doc.id, ...doc.data() };
        supplierData.push(supplier);
        supplierEmails[supplier.id] = supplier.email;
      });

      setSuppliers(supplierData);
      setSelectedSupplierEmails(supplierEmails);
    };

    fetchSuppliers();
  }, [orderId]);

  if (!order || suppliers.length === 0) {
    return <div>Loading...</div>;
  }

  const calculateTotalPrice = (item) => {
    const matchingSupplier = suppliers.find((supplier) =>
      supplier.items.some(
        (i) => i.itemName.toLowerCase() === item.name.toLowerCase()
      )
    );
    if (matchingSupplier) {
      const supplierItem = matchingSupplier.items.find(
        (i) => i.itemName.toLowerCase() === item.name.toLowerCase()
      );
      return (unitPrices[item.id] || supplierItem.price) * item.quantity;
    }
    return 0;
  };

  const handleCommentChange = (comment) => {
    setOrderComment(comment);
  };

  const handleUnitPriceChange = (itemId, price) => {
    setUnitPrices({ ...unitPrices, [itemId]: parseFloat(price) });
  };

  const handleSupplierChange = (itemId, supplierId) => {
    setSelectedSuppliers({ ...selectedSuppliers, [itemId]: supplierId });
  };

  const handleApprove = async () => {
    try {
      const db = getFirestore();
      const orderRef = doc(db, "orders", orderId);

      const itemsWithSupplierEmails = order.items.map((item) => ({
        ...item,
        supplierEmail: selectedSupplierEmails[selectedSuppliers[item.id]] || "",
      }));

      // Calculate the total price for the order
      let totalPrice = 0;
      order.items.forEach((item) => {
        totalPrice += calculateTotalPrice(item);
      });

      const updatedOrder = {
        status: 2,
        comment: orderComment,
        supplier: itemsWithSupplierEmails[0].supplierEmail || "",
        items: order.items.map((item) => ({
          ...item,
          price: unitPrices[item.id] || 0,
        })),
        totalPrice: totalPrice, // Update the totalPrice in the order
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
  const handleReject = async () => {
    try {
      const db = getFirestore();
      const orderRef = doc(db, "orders", orderId);

      const itemsWithSupplierEmails = order.items.map((item) => ({
        ...item,
        supplierEmail: selectedSupplierEmails[selectedSuppliers[item.id]] || "",
      }));

      // Calculate the total price for the order
      let totalPrice = 0;
      order.items.forEach((item) => {
        totalPrice += calculateTotalPrice(item);
      });

      const updatedOrder = {
        status: 6,
        comment: orderComment,
        supplier: itemsWithSupplierEmails[0].supplierEmail || "",
        items: order.items.map((item) => ({
          ...item,
          price: unitPrices[item.id] || 0,
        })),
        totalPrice: totalPrice, // Update the totalPrice in the order
      };

      await updateDoc(orderRef, updatedOrder);

      toast.success("Order reject successfully", { autoClose: 3000 });

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
        <h2>Order Details</h2>
        <p>Construction Site: {order.constructionSite}</p>
        <p>Date: {order.date.toDate().toLocaleString()}</p>
        <p>Site Manager: {order.sitemanager}</p>

        <h3>Items</h3>
        <table className="table table-striped table-bordered">
          <thead className="thead-dark">
            <tr>
              <th scope="col">Item Name</th>
              <th scope="col">Quantity</th>
              <th scope="col">Supplier</th>
              <th scope="col">Unit Price</th>
              <th scope="col">Total Price</th>
              <th scope="col">Comment</th>
              <th scope="col">Action</th>
            </tr>
          </thead>
          <tbody>
            {order.items.map((item, index) => (
              <tr key={index}>
                <td>{item.name}</td>
                <td>{item.quantity}</td>
                <td>
                  <select
                    className="form-control"
                    value={selectedSuppliers[item.id] || ""}
                    onChange={(e) =>
                      handleSupplierChange(item.id, e.target.value)
                    }
                  >
                    <option value="">Select Supplier</option>
                    {suppliers.map((supplier) => (
                      <option key={supplier.id} value={supplier.id}>
                        {supplier.supplierName}
                      </option>
                    ))}
                  </select>
                </td>
                <td>
                  <input
                    type="number"
                    className="form-control"
                    placeholder="Unit Price"
                    value={unitPrices[item.id] || ""}
                    onChange={(e) =>
                      handleUnitPriceChange(item.id, e.target.value)
                    }
                  />
                </td>
                <td>{calculateTotalPrice(item)}</td>
                <td>
                  <input
                    type="text"
                    className="form-control"
                    placeholder="Add Comment"
                    value={orderComment}
                    onChange={(e) => handleCommentChange(e.target.value)}
                  />
                </td>
                <td className="text-center align-middle">
                  <div className="btn-group">
                    <button onClick={handleApprove} className="btn btn-primary btn-sm">Approve</button>
                    <button onClick={handleReject} className="btn btn-danger btn-sm">Reject</button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default AdminOrderDetails;
