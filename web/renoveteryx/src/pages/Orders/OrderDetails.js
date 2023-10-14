import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { getFirestore, doc, getDoc, collection, getDocs, deleteDoc, addDoc, updateDoc, arrayRemove } from 'firebase/firestore';
import { Form, Table, Button } from 'react-bootstrap';
import { format, fromUnixTime } from "date-fns";

function OrderDetails() {
    const { docId } = useParams();
    const navigate = useNavigate();
    const [orderData, setOrderData] = useState(null);
    const [suppliers, setSuppliers] = useState([]);
    const [totals, setTotals] = useState({});

    const mapStatusToText = (status) => {
        switch (status) {
            case 1:
                return 'Pending';
            case 2:
                return 'Send to Supplier';
            case 3:
                return 'Send to Manager';
            case 4:
                return 'Supplier Accepted';
            case 5:
                return 'Supplier Rejected';
            default:
                return 'Unknown';
        };
    };

    useEffect(() => {
        fetchOrderData();
        fetchSuppliers();
    }, [docId]);

    const fetchOrderData = async () => {

        const db = getFirestore();
        const orderRef = doc(db, 'orders', docId);
        console.log(orderRef)

        try {
            const orderSnapshot = await getDoc(orderRef);
            console.log(orderSnapshot.data().items.length);
            if (orderSnapshot.exists()) {
                const data = orderSnapshot.data();
                setOrderData(data);
            } else {
                console.log('Order not found.');
            }
        } catch (error) {
            console.error('Error fetching order data:', error);
        }
    };

    const fetchSuppliers = async () => {

        const db = getFirestore();

        const suppliersCollection = collection(db, 'suppliers');
        const suppliersSnapshot = await getDocs(suppliersCollection);
        const supplierData = [];
        suppliersSnapshot.forEach((doc) => {
            supplierData.push(doc.data());
        });
        setSuppliers(supplierData);
    };

    if (!orderData) {
        return <div>Loading...</div>;
    }

    const isSendToManager = calculateTotal(0) > 100000;

    return (
        <div className="container">
            <h2>Order Details</h2>
            <p>Order ID: {docId}</p>
            <p>Site Manager: {orderData.siteManager}</p>
            <p>Status: {mapStatusToText(orderData.status)}</p>
            <p>Date: {format(fromUnixTime(orderData.date.seconds), "MM/dd/yyyy HH:mm:ss")}</p>
            <p>Construction Site: {orderData.constructionSite}</p>
            <p>Total: {orderData.total}</p>

            <h3>Items</h3>

            <Table striped bordered hover>
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Quantity</th>
                        <th>Supplier</th>
                        <th>Price</th>
                        <th>Total</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    {orderData.items.map((item, index) => {
                        const filteredSuppliers = suppliers.filter((supplier) => supplier.items[item.name]);
                        const isSendToManager = calculateTotal(index) > 100000;

                        return (
                            <tr key={index}>
                                <td>{item.name}</td>
                                <td>{item.quantity}</td>
                                <td>
                                    <Form.Select
                                        onChange={(e) => handleSupplierChange(index, e.target.value)}
                                        value={selectedSupplierForItem(index)}
                                    >
                                        <option value="" disabled>Select a supplier</option>
                                        {filteredSuppliers.map((supplier, supplierIndex) => (
                                            <option key={supplierIndex} value={supplier.email}>
                                                {supplier.name} - Price: {supplier.items[item.name]}
                                            </option>
                                        ))}
                                    </Form.Select>
                                </td>
                                <td>{selectedSupplierPrice(index)}</td>
                                <td>{calculateTotal(index)}</td>
                                <td>
                                    {isSendToManager ? (
                                        <Button variant="primary" onClick={() => handleSendToManager(index)}>
                                            Send to Manager
                                        </Button>
                                    ) : (
                                        <Button variant="success" onClick={() => handleSendToSupplier(index)}>
                                            Send to Supplier
                                        </Button>
                                    )}
                                </td>
                            </tr>
                        );
                    })}
                </tbody>
            </Table>
        </div>
    );

    function handleSupplierChange(index, supplierEmail) {
        const updatedItems = [...orderData.items];
        updatedItems[index].selectedSupplier = supplierEmail;
        setOrderData({ ...orderData, items: updatedItems });
    }

    function selectedSupplierForItem(index) {
        return orderData.items[index].selectedSupplier || "";
    }

    function selectedSupplierPrice(index) {
        const selectedItem = orderData.items[index];
        const selectedSupplier = suppliers.find((supplier) => supplier.email === selectedItem.selectedSupplier);
        if (selectedSupplier) {
            return selectedSupplier.items[selectedItem.name];
        }
        return 0;
    }

    function calculateTotal(index) {
        const selectedItem = orderData.items[index];
        const total = selectedItem.quantity * selectedSupplierPrice(index);
        return total;
    }

    function handleSendToManager(index) {
        const selectedItem = orderData.items[index];
        const selectedSupplier = selectedItem.selectedSupplier;

        if (selectedSupplier) {
            // Logic to send the order to the supplier
            const newOrderData = {
                ...orderData,
                status: 3, // Change the status to 3 (Send to Supplier)
                items: [selectedItem], // Send only the selected item
            };

            // Add the new order to the "orders" collection and set the supplier
            addOrderToCollection(newOrderData, selectedSupplier);

            // Remove the item from the previous collection
            removeItemFromCollection(index);

            fetchOrderData();
        }
    }

    function handleSendToSupplier(index) {
        const selectedItem = orderData.items[index];
        const selectedSupplier = selectedItem.selectedSupplier;

        if (selectedSupplier) {
            // Logic to send the order to the supplier
            const newOrderData = {
                ...orderData,
                status: 2, // Change the status to 2 (Send to Supplier)
                items: [selectedItem], // Send only the selected item
            };

            // Add the new order to the "orders" collection and set the supplier
            addOrderToCollection(newOrderData, selectedSupplier);

            // Remove the item from the previous collection
            removeItemFromCollection(index);

            fetchOrderData();
        }
    }

    async function addOrderToCollection(newOrderData, selectedCustomer) {
        // Get a reference to the Firestore database
        const db = getFirestore();

        // Get a reference to the "orders" collection
        const ordersCollection = collection(db, 'orders');

        try {
            // Add the selected customer to the "supplier" field
            newOrderData.supplier = selectedCustomer;

            // Add the new order to the "orders" collection
            await addDoc(ordersCollection, newOrderData);
            console.log("New Order added");
        } catch (error) {
            console.error('Error adding new order to the collection:', error);
        }
    }


    async function removeItemFromCollection(index) {

        const db = getFirestore();

        const selectedItem = orderData.items[index];
        const name = selectedItem.name;
        const quantity = selectedItem.quantity;

        const itemToRemove = {
            name: name,
            quantity: quantity
        };

        console.log(itemToRemove);

        const specificOrderRef = doc(db, 'orders', docId);

        try {
            await updateDoc(specificOrderRef, {
                items: arrayRemove(itemToRemove)
            });

            const orderSnapshot = await getDoc(specificOrderRef);
            const itemsLength = orderSnapshot.data().items.length;
            console.log(itemsLength)

            if (itemsLength === 1) {
                // If "items" array is now empty, delete the entire document
                await deleteDoc(specificOrderRef);
                console.log("Document deleted because 'items' array is empty.");
            } else {
                console.log("Item removed successfully.");
            }

        } catch (error) {
            console.error("Error removing item: ", error);
        }
    }

}

export default OrderDetails;