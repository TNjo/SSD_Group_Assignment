import React, { useState, useEffect } from "react";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import DashboardHeader from "../../components/DashboardHeader";
import * as firebaseServices from "../../firebaseServices/firebaseServices";
import CryptoJS from "crypto-js"; // Importing CryptoJS for encryption

function SiteForm2() {
    const [siteData, setSiteData] = useState({
        id: "",
        name: "",
        location: "",
        sitemanager: "",
        budget: 0,
    });

    const [managerNames, setManagerNames] = useState([]);
    const [errors, setErrors] = useState({});

    const [lastSubmitTime, setLastSubmitTime] = useState(0);
    const MIN_INTERVAL = 5000; // Set the minimum interval between submissions to 5 seconds

    useEffect(() => {
        const fetchManagerNames = async () => {
            const names = await firebaseServices.fetchManagerNames();
            setManagerNames(names);
        };

        fetchManagerNames();
    }, []);

    const validateForm = () => {
        const errors = {};

        if (!siteData.id.trim()) {
            errors.id = "ID is required";
        }

        if (!siteData.name.trim()) {
            errors.name = "Name is required";
        }

        if (!siteData.location.trim()) {
            errors.location = "Location is required";
        }

        if (!siteData.sitemanager) {
            errors.sitemanager = "Site Manager is required";
        }

        if (siteData.budget <= 0) {
            errors.budget = "Budget must be greater than 0";
        }

        setErrors(errors);

        return Object.keys(errors).length === 0;
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setSiteData({ ...siteData, [name]: value });
        // Clear the error message when the user starts typing
        setErrors({ ...errors, [name]: null });
    };

    // Access secret key from .env file
    const secretKey = String(process.env.REACT_APP_CRYPTO_SECRET_KEY);

    const handleFormSubmit = async (e) => {
        e.preventDefault();

        const now = Date.now();
        if (now - lastSubmitTime < MIN_INTERVAL) {
            toast.error("You're submitting too fast. Please wait.");
            return;
        }
        setLastSubmitTime(now);
        if (!validateForm()) {
            return;
        }
        // Encrypt the budget field only before submitting the data
        const encryptedSiteData = {
            ...siteData,
            budget: CryptoJS.AES.encrypt(siteData.budget.toString(), secretKey).toString(),
        };
        try {
            const docId = await firebaseServices.addSiteData(encryptedSiteData);
            toast.success("Site data added successfully");
            console.log("Site data added successfully");
            setSiteData({
                id: "",
                name: "",
                location: "",
                sitemanager: "",
                budget: 0,
            });
        } catch (error) {
            console.error("Error adding document: ", error);
            toast.error("Failed to add site data. Please try again later.");
        }
    };

    return (
        <div className="dashboard-content">
            <DashboardHeader btnText="New Order" />
            <div className="dashboard-content-container">
                <h2>Add Construction Site</h2>
                <form onSubmit={handleFormSubmit}>
                    <div className="mb-3">
                        <label className="form-label">ID</label>
                        <input
                            type="text"
                            name="id"
                            data-testid="id-input"
                            className="form-control"
                            value={siteData.id}
                            onChange={handleInputChange}
                        />
                        {errors.id && <div className="text-danger">{errors.id}</div>}
                    </div>
                    <div className="mb-3">
                        <label className="form-label">Name</label>
                        <input
                            type="text"
                            name="name"
                            data-testid="name-input"
                            className="form-control"
                            value={siteData.name}
                            onChange={handleInputChange}
                        />
                        {errors.name && <div className="text-danger">{errors.name}</div>}
                    </div>
                    <div className="mb-3">
                        <label className="form-label">Location</label>
                        <input
                            type="text"
                            name="location"
                            data-testid="location-input"
                            className="form-control"
                            value={siteData.location}
                            onChange={handleInputChange}
                        />
                        {errors.location && (
                            <div className="text-danger">{errors.location}</div>
                        )}
                    </div>
                    <div className="mb-3">
                        <label className="form-label">Site Manager</label>
                        <select
                            name="sitemanager"
                            data-testid="sitemanager-select"
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
                        {errors.sitemanager && (
                            <div className="text-danger">{errors.sitemanager}</div>
                        )}
                    </div>
                    <div className="mb-3">
                        <label className="form-label">Budget</label>
                        <input
                            type="number"
                            name="budget"
                            data-testid="budget-input"
                            className="form-control"
                            value={siteData.budget}
                            onChange={handleInputChange}
                        />
                        {errors.budget && (
                            <div className="text-danger">{errors.budget}</div>
                        )}
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

export default SiteForm2;
