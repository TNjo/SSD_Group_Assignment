import React, { useState, useEffect } from "react";
import DashboardHeader from "../../components/DashboardHeader";
import * as firebaseServices from "../../firebaseServices/firebaseServices";
import { calculateRange, sliceData } from "../../utils/table-pagination";
import "../styles.css";

function AdminSuppliers() {
  const [search, setSearch] = useState("");
  const [suppliers, setSuppliers] = useState([]);
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState([]);

  const fetchData = async () => {
    try {
      const suppliersData = await firebaseServices.fetchSuppliersData();

      // Calculate pagination
      setSuppliers(suppliersData);
      setPagination(calculateRange(suppliersData, 5));
      setSuppliers(sliceData(suppliersData, page, 5));
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  };

  useEffect(() => {
    fetchData();
  }, [page]);

  const handlePaginationChange = (newPage) => {
    setPage(newPage);
    setSuppliers(sliceData(suppliers, newPage, 5));
  };

  const handleSearch = (event) => {
    setSearch(event.target.value);
  };

  useEffect(() => {
    const filterSuppliers = () => {
      if (search === "") {
        fetchData(); // Call fetchData here
      } else {
        const searchResults = suppliers.filter(
          (item) =>
            item.supplierName.toLowerCase().includes(search.toLowerCase()) ||
            item.email.toLowerCase().includes(search.toLowerCase()) ||
            item.contact.toLowerCase().includes(search.toLowerCase())
        );
        setSuppliers(searchResults);
      }
    };

    filterSuppliers();
  }, [search, suppliers]); // Add 'suppliers' as a dependency

  const handleDeleteSupplier = async (supplierId) => {
    try {
      await firebaseServices.deleteSupplier(supplierId);
      const updatedSuppliers = suppliers.filter(
        (supplier) => supplier.id !== supplierId
      );
      setSuppliers(updatedSuppliers);
    } catch (error) {
      console.error("Error deleting supplier:", error);
    }
  };

  return (
    <div className="dashboard-content">
      <DashboardHeader btnText="New Supplier" />

      <div className="dashboard-content-container">
        <div className="dashboard-content-header">
          <h2>Suppliers List</h2>
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

        <table className="table">
          <thead>
            <tr>
              <th scope="col">Name</th>
              <th scope="col">Email</th>
              <th scope="col">Contact</th>
              <th scope="col">Available Items</th>
              <th scope="col">Action</th>
            </tr>
          </thead>

          {suppliers.length !== 0 ? (
            <tbody>
              {suppliers.map((supplier, index) => (
                <tr key={index}>
                  <td>{supplier.supplierName}</td>
                  <td>{supplier.email}</td>
                  <td>{supplier.contact}</td>
                  <td>
                    {supplier.items.map((item, itemIndex) => (
                      <div key={itemIndex}>
                        {item.itemName}: {item.quantity}
                      </div>
                    ))}
                  </td>
                  <td>
                    <div>
                      <button
                        className="btn btn-warning btn-sm"
                        onClick={() => handleDeleteSupplier(supplier.id)}
                      >
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          ) : null}
        </table>

        {suppliers.length !== 0 ? (
          <div className="dashboard-content-footer">
            {pagination.map((item, index) => (
              <span
                key={index}
                className={item === page ? "active-pagination" : "pagination"}
                onClick={() => handlePaginationChange(item)}
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
      </div>
    </div>
  );
}

export default AdminSuppliers;
