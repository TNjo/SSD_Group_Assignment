import React, { useEffect, useState } from 'react';
import Table from 'react-bootstrap/Table';
import Select from 'react-select';
import { useParams } from 'react-router-dom';
import { getFirestore, doc, getDoc, collection, getDocs, addDoc, updateDoc } from 'firebase/firestore';
import { format, fromUnixTime } from 'date-fns';


const OrderDetails = () => {

    const [selectedSuppliers, setSelectedSuppliers] = useState({});
    console.log(selectedSuppliers)
    const { docId } = useParams();
    const [orderData, setOrderData] = useState(null);
    const [suppliersData, setSuppliersData] = useState(null);

    useEffect(() => {
        fetchOrderData();
        fetchSupplierData();
    }, [docId]);

    const fetchOrderData = async () => {
        const db = getFirestore();
        const orderRef = doc(db, 'orders', docId);

        try {
            const orderSnapshot = await getDoc(orderRef);
            if (orderSnapshot.exists()) {
                const data = orderSnapshot.data();
                setOrderData(data);
                console.log()
            } else {
                console.log('Order not found.');
            }
        } catch (error) {
            console.error('Error fetching order data:', error);
        }
    };

    const fetchSupplierData = async () => {
        try {
            const db = getFirestore();

            const suppliersCollection = collection(db, "suppliers");
            const suppliersSnapshot = await getDocs(suppliersCollection);

            const suppliers = suppliersSnapshot.docs.map((doc) => {
                const data = doc.data();
                data.id = doc.id;
                return data;
            });

            // Set the suppliers data to the state
            setSuppliersData(suppliers);
            console.log(suppliers)
        } catch (error) {
            // Handle errors here
            console.error("Error fetching supplier data:", error);
        }
    };

    // Convert the date to a JavaScript Date object


    const handleSupplierChange = (itemName, supplierData) => {
        setSelectedSuppliers({ ...selectedSuppliers, [itemName]: supplierData });
    };

    const calculateTotal = (item) => {
        if (selectedSuppliers[item.name] && selectedSuppliers[item.name].items) {
            const supplierItem = selectedSuppliers[item.name].items.find(
                (supplierItem) => supplierItem.itemName === item.name
            );
            if (supplierItem) {
                return item.quantity * supplierItem.price;
            }
        }
        return 0;
    };

    const sendToSupplier = (itemName) => {
        const item = orderData.items.find((i) => i.name === itemName);
        const selectedSupplier = selectedSuppliers[itemName];

        if (item && selectedSupplier) {
            const order = {
                constructionSite: orderData.constructionSite,
                date: orderData.date,
                items: [
                    {
                        name: item.name,
                        quantity: item.quantity,
                        price: selectedSupplier.items.find((i) => i.itemName === item.name).price,
                    },
                ],
                orderid: orderData.orderid + 1,
                sitemanager: orderData.sitemanager,
                status: 2,
                supplier: selectedSupplier.email,
                totalPrice: item.quantity * selectedSupplier.items.find((i) => i.itemName === item.name).price,
            };

            console.log('Order to Supplier:', order);
            createOrderDocument(order);
            console.log('Order Item to Delete:', order.items[0].name);
            deleteItemFromOrder(order.items[0].name);
        } else {
            console.error("No item or supplier selected")
        }
    };

    const sendToManager = (itemName) => {
        const item = orderData.items.find((i) => i.name === itemName);
        const selectedSupplier = selectedSuppliers[itemName];

        if (item && selectedSupplier) {
            const order = {
                constructionSite: orderData.constructionSite,
                date: orderData.date,
                items: [
                    {
                        name: item.name,
                        quantity: item.quantity,
                        price: selectedSupplier.items.find((i) => i.itemName === item.name).price,
                    },
                ],
                orderid: orderData.orderid + 1,
                sitemanager: orderData.sitemanager,
                status: 3,
                supplier: selectedSupplier.email,
                totalPrice: item.quantity * selectedSupplier.items.find((i) => i.itemName === item.name).price,
            };

            console.log('Order to Supplier:', order);
            createOrderDocument(order);
            console.log('Order Item to Delete:', order.items[0].name);
            deleteItemFromOrder(order.items[0].name);
        } else {
            console.error("No item or supplier selected")
        }
    };

    const createOrderDocument = async (order) => {
        try {
            const db = getFirestore();
            const ordersCollection = collection(db, 'orders');
            await addDoc(ordersCollection, order);
            console.log('Order document created in Firestore:', order);
        } catch (error) {
            console.error('Error creating order document:', error);
        }
    };

    const deleteItemFromOrder = async (itemNameToDelete) => {
        const db = getFirestore();
        const orderDocRef = doc(db, 'orders', docId);
        try {
            const orderSnapshot = await getDoc(orderDocRef);
            if (orderSnapshot.exists()) {
                const orderData = orderSnapshot.data();

                // Filter out the item to be deleted
                const updatedItems = orderData.items.filter((item) => item.name !== itemNameToDelete);

                // Update the document with the modified items list
                await updateDoc(orderDocRef, {
                    items: updatedItems,
                });

                console.log(`Item '${itemNameToDelete}' deleted from the order.`);
            } else {
                console.log('Order document not found.');
            }
        } catch (error) {
            console.error('Error deleting item:', error);
        }
    };


    return (
        <div>
            {orderData ? (
                <div>
                    <h1>Order Details</h1>
                    <p><strong>Construction Site:</strong> {orderData.constructionSite}</p>
                    <p><strong>Date:</strong> {format(fromUnixTime(orderData.date.seconds), "MM/dd/yyyy HH:mm:ss")}</p>
                    <p><strong>Order ID:</strong> {orderData.orderid}</p>
                    <p><strong>Site Manager:</strong> {orderData.sitemanager}</p>
                    <p><strong>Status:</strong> {orderData.status}</p>

                    <h2>Items</h2>
                    <Table striped bordered hover>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Quantity</th>
                                <th>Supplier</th>
                                <th>Total</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {orderData.items.map((item, index) => (
                                <tr key={index}>
                                    <td>{item.name}</td>
                                    <td>{item.quantity}</td>
                                    <td>
                                        {suppliersData ? (
                                            <Select
                                                value={selectedSuppliers[item]}
                                                onChange={(selectedOption) => {
                                                    const selectedSupplier = suppliersData.find(
                                                        (supplier) => supplier.supplierName === selectedOption.value
                                                    );
                                                    handleSupplierChange(item.name, selectedSupplier);
                                                }}
                                                options={suppliersData
                                                    .filter((supplier) =>
                                                        supplier.items.find(
                                                            (supplierItem) => supplierItem.itemName === item.name
                                                        )
                                                    )
                                                    .map((supplier) => ({
                                                        value: supplier.supplierName,
                                                        label: (
                                                            <div>
                                                                {supplier.supplierName} (Price: {supplier.items.find(
                                                                    (supplierItem) => supplierItem.itemName === item.name
                                                                ).price})
                                                            </div>
                                                        ),
                                                    }))
                                                }
                                                isClearable
                                            />
                                        ) : (
                                            <div> no suppliers found</div>
                                        )}
                                    </td>
                                    <td>{calculateTotal(item)}</td>
                                    <td>
                                        {calculateTotal(item) > 100000 ? (
                                            <button onClick={() => sendToManager(item.name)}>Send to Manager</button>
                                        ) : (
                                            <button onClick={() => sendToSupplier(item.name)}>Send to Supplier</button>
                                        )}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </Table>
                </div>
            ) : (
                <p>Loading order data...</p>
            )}
        </div>
    );
};

export default OrderDetails;