import React, { useState, useEffect } from "react";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import DashboardHeader from "../../components/DashboardHeader";
import * as firebaseServices from "../../firebaseServices/firebaseServices";

function SiteForm() {
  const [siteData, setSiteData] = useState({
    id: "",
    name: "",
    location: "",
    sitemanager: "",
    budget: 0,
  });

  const [managerNames, setManagerNames] = useState([]);

  useEffect(() => {
    const fetchManagerNames = async () => {
      const names = await firebaseServices.fetchManagerNames();
      setManagerNames(names);
    };

    fetchManagerNames();
  }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setSiteData({ ...siteData, [name]: value });
  };

  const handleFormSubmit = async (e) => {
    e.preventDefault();

    if (
      !siteData.id ||
      !siteData.name ||
      !siteData.location ||
      !siteData.sitemanager ||
      !siteData.budget
    ) {
      toast.error("All fields are required");
      return;
    }

    try {
      const docId = await firebaseServices.addSiteData(siteData);

      toast.success("Site data added successfully");

      setSiteData({
        id: "",
        name: "",
        location: "",
        sitemanager: "",
        budget: 0,
      });
    } catch (error) {
      console.error("Error adding document: ", error);
      toast.error(error.message);
    }
  };

  return (
    <div className="dashboard-content">
      <DashboardHeader btnText="New Order" />
      <div className="dashboard-content-container">
        <form onSubmit={handleFormSubmit}>
          <div className="mb-3">
            <label className="form-label">ID</label>
            <input
              type="text"
              name="id"
              className="form-control"
              value={siteData.id}
              onChange={handleInputChange}
            />
          </div>
          <div className="mb-3">
            <label className="form-label">Name</label>
            <input
              type="text"
              name="name"
              className="form-control"
              value={siteData.name}
              onChange={handleInputChange}
            />
          </div>
          <div className="mb-3">
            <label className="form-label">Location</label>
            <input
              type="text"
              name="location"
              className="form-control"
              value={siteData.location}
              onChange={handleInputChange}
            />
          </div>
          <div className="mb-3">
            <label className="form-label">Site Manager</label>
            <select
              name="sitemanager"
              className="form-select"
              value={siteData.sitemanager}
              onChange={handleInputChange}
            >
              <option value="">Select Site Manager</option>
              {managerNames.map((managerName, index) => (
                <option key={index} value={managerName}>
                  {managerName}
                </option>
              ))}
            </select>
          </div>
          <div className="mb-3">
            <label className="form-label">Budget</label>
            <input
              type="number"
              name="budget"
              className="form-control"
              value={siteData.budget}
              onChange={handleInputChange}
            />
          </div>
          <button type="submit" className="btn btn-primary">
            Add Site
          </button>
        </form>
      </div>
      <ToastContainer position="bottom-right" autoClose={3000} />
    </div>
  );
}

export default SiteForm;
