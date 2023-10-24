import React, { useContext, useEffect, useState } from 'react';
import Table from 'react-bootstrap/Table';
import Select from 'react-select';
import { useNavigate, useParams } from 'react-router-dom';
import { format, fromUnixTime } from 'date-fns';
import { fetchOrderData, fetchSupplierData, createOrderDocument, deleteItemFromOrder, fetchSiteBudget, updateSiteBudget } from "../../services/FirebaseServices";
import { getStatusText } from "../../constants/getStatusText"
import { toast } from 'react-toastify';
import ToastContext from '../../Context/ToastContext';
import progressBar from '../../components/progressBar';

const OrderDetails = () => {

    const navigate = useNavigate();
    const { toast } = useContext(ToastContext);
    const [selectedSuppliers, setSelectedSuppliers] = useState({});
    console.log(selectedSuppliers)
    const { docId } = useParams();
    const [orderData, setOrderData] = useState(null);
    const [suppliersData, setSuppliersData] = useState(null);
    const [siteBudget, setSiteBudget] = useState(null);
    const [overallTotal, setOverallTotal] = useState(0);

    useEffect(() => {
        fetchData();
    }, [docId]);

    useEffect(() => {
        // Calculate and update the overall total whenever selectedSuppliers or orderData change
        if (selectedSuppliers && orderData) {
            const total = orderData.items.reduce((acc, item) => {
                const rowTotal = calculateTotal(item);
                return acc + rowTotal;
            }, 0);
            setOverallTotal(total);
            console.log(total)
        }
    }, [selectedSuppliers, orderData]);

    const fetchData = async () => {
        const orderData = await fetchOrderData(docId);
        const suppliersData = await fetchSupplierData();

        if (orderData && suppliersData) {
            setOrderData(orderData);
            setSuppliersData(suppliersData);

            const siteBudget = await fetchSiteBudget(orderData.constructionSite);
            setSiteBudget(siteBudget);

            console.log(siteBudget)
        }
    };


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

    const sendToSupplierOrManager = (itemName, status) => {
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
                sitemanagerId: orderData.sitemanagerId,
                status: status,
                supplier: selectedSupplier.email,
                totalPrice: item.quantity * selectedSupplier.items.find((i) => i.itemName === item.name).price,
            };

            try {
                console.log('Order to Supplier:', order);
                createOrderDocument(order);
                toast.success("Order item sent succesfully")
                console.log('Order Item to Delete:', order.items[0].name);
                deleteItemFromOrder(order.items[0].name, docId);
                toast.success("Order items deleted from list");
                updateSiteBudget(orderData.constructionSite, overallTotal);
                toast.success("Budget updated");


                // Update the orderData and selectedSuppliers states
                setOrderData((prevOrderData) => {
                    // Remove the item from the orderData
                    const updatedItems = prevOrderData.items.filter((item) => item.name !== itemName);
                    console.log(updatedItems)
                    if (updatedItems.length === 0) {
                        toast.success("Order deleted because no items left")
                        navigate("/pm")
                    }
                    return { ...prevOrderData, items: updatedItems };
                });
                setSelectedSuppliers({});
            } catch (error) {
                toast.error(`Error : ${error}`);
            }

        } else {
            toast.error("No item or supplier selected")
            console.error("No item or supplier selected")
        }
    };

    return (

        <div className="mx-5 my-3">
            <div>
                {orderData ? (
                    <div>
                        <div>
                            <div>
                                <h1>Order Details</h1>
                                <p><strong>Construction Site:</strong> {orderData.constructionSite}</p>
                                <p><strong>Date:</strong> {format(fromUnixTime(orderData.date.seconds), "MM/dd/yyyy HH:mm:ss")}</p>
                                <p><strong>Order ID:</strong> {orderData.orderid}</p>
                                <p><strong>Site Manager:</strong> {orderData.sitemanager}</p>
                                <p><strong>Status:</strong> {getStatusText(orderData.status)}</p>
                                <p><strong>Budget:</strong> {siteBudget}</p>
                            </div>
                            <div>
                                {progressBar(siteBudget, overallTotal)}
                            </div>
                        </div>
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
                                                <button className='btn btn-success' onClick={() => sendToSupplierOrManager(item.name, 3)}>Send to Manager</button>
                                            ) : (
                                                <button className='btn btn-warning' onClick={() => sendToSupplierOrManager(item.name, 2)}>Send to Supplier</button>
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
        </div>
    );
};

export default OrderDetails;