import React, { useState, useEffect } from "react";
import DashboardHeader from "../../components/DashboardHeader";
import { calculateRange, sliceData } from "../../utils/table-pagination";
import { fetchSiteData } from "../../firebaseServices/firebaseServices";
import "../styles.css";
import { Link } from "react-router-dom";
import CryptoJS from "crypto-js"; // Importing CryptoJS for decryption

function Sites2() {
    const [search, setSearch] = useState("");
    const [sites, setSites] = useState([]);
    const [page, setPage] = useState(1);
    const [pagination, setPagination] = useState([]);

    useEffect(() => {
        fetchData();
    }, [page]);

    // Access secret key from .env file
    const secretKey = String(process.env.REACT_APP_CRYPTO_SECRET_KEY);

    const fetchData = async () => {
        try {
            const sitesData = await fetchSiteData();

            // Decrypting the 'budget' field for each site
            const decryptedSitesData = sitesData.map((site) => ({
                ...site,
                budget: CryptoJS.AES.decrypt(site.budget, secretKey).toString(CryptoJS.enc.Utf8), // Decrypting budget
            }));

            setSites(decryptedSitesData);

            setPagination(calculateRange(decryptedSitesData, 5));
            setSites(sliceData(decryptedSitesData, page, 5));
        } catch (error) {
            console.error("Error fetching data");
        }
    };

    const handleSearch = (event) => {
        setSearch(event.target.value);
        if (event.target.value === "") {
            fetchData(); // Reset the data if the search input is empty
        } else {
            const searchResults = sites.filter(
                (item) =>
                    item.id.toLowerCase().includes(search.toLowerCase()) ||
                    item.name.toLowerCase().includes(search.toLowerCase()) ||
                    item.location.toLowerCase().includes(search.toLowerCase()) ||
                    item.sitemanager.toLowerCase().includes(search.toLowerCase()) ||
                    item.budget.toString().toLowerCase().includes(search.toLowerCase()) // Include decrypted budget in search
            );
            setSites(searchResults);
        }
    };

    const handleChangePage = (new_page) => {
        setPage(new_page);
        setSites(sliceData(sites, new_page, 5));
    };

    return (
        <div>
            <DashboardHeader btnText="New Site Manager" />
            <div>
                <Link
                    to={`/admin-addSites`}
                    type="button"
                    className="btn btn-primary ms-3"
                >
                    Add Site
                </Link>
            </div>
            <div className="dashboard-content-container">
                <div className="dashboard-content-header">
                    <h2>Sites List</h2>
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
                            <th scope="col">ID</th>
                            <th scope="col">NAME</th>
                            <th scope="col">LOCATION</th>
                            <th scope="col">SITE MANAGER</th>
                            <th scope="col">BUDGET</th>
                            <th scope="col">Action</th>
                        </tr>
                    </thead>

                    {sites.length !== 0 ? (
                        <tbody>
                            {sites.map((site, index) => (
                                <tr key={index}>
                                    <td>{site.id}</td>
                                    <td>{site.name}</td>
                                    <td>{site.location}</td>
                                    <td>{site.sitemanager}</td>
                                    <td>{site.budget}</td> {/* Displaying decrypted budget */}
                                    <td>
                                        <div>
                                            <button className="btn btn-warning btn-sm">Edit</button>
                                            <button className="btn btn-danger btn-sm ms-1">
                                                Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    ) : null}
                </table>

                {sites.length !== 0 ? (
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
                ) : (
                    <div className="dashboard-content-footer">
                        <span className="empty-table">No data</span>
                    </div>
                )}
            </div>
        </div>
    );
}

export default Sites2;
