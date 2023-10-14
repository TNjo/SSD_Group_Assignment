import React, { useState, useEffect } from "react";
import DashboardHeader from "../../components/DashboardHeader";
import { getFirestore, collection, getDocs } from "firebase/firestore";
import { calculateRange, sliceData } from "../../utils/table-pagination";
import "../styles.css";
import { Link } from "react-router-dom";

function Sites() {
  // Changed the function name to Sites
  const [search, setSearch] = useState("");
  const [sites, setSites] = useState([]); // Changed state variable and variable names to "sites"
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState([]);
  const db = getFirestore();

  const fetchData = async () => {
    const sitesCollection = collection(db, "sites"); // Changed the collection name to "sites"
    const sitesSnapshot = await getDocs(sitesCollection);
    const sitesData = sitesSnapshot.docs.map((doc) => doc.data());
    // Set the sites data to the state
    setSites(sitesData);

    // Calculate pagination
    setPagination(calculateRange(sitesData, 5));
    setSites(sliceData(sitesData, page, 5));
  };

  useEffect(() => {
    fetchData();
  }, [page]);

  // Search
  const handleSearch = (event) => {
    setSearch(event.target.value);
    if (event.target.value === "") {
      fetchData(); // Reset the data if the search input is empty
    } else {
      const searchResults = sites.filter(
        (item) =>
          item.name.toLowerCase().includes(search.toLowerCase()) ||
          item.location.toLowerCase().includes(search.toLowerCase()) ||
          item.sitemanager.toLowerCase().includes(search.toLowerCase()) ||
          item.id.includes(search)
      );
      setSites(searchResults);
    }
  };

  // Change Page
  const handleChangePage = (new_page) => {
    setPage(new_page);
    setSites(sliceData(sites, new_page, 5));
  };

  return (
    <div>
      <DashboardHeader btnText="New Site Manager" />
      <div>
        <Link to={`/admin-addSites`} type="button" class="btn btn-primary ms-3">
          Add Site
        </Link>
      </div>
      <div className="dashboard-content-container">
        <div className="dashboard-content-header">
          <h2>Sites List</h2>{" "}
          {/* Changed "Site Managers List" to "Sites List" here */}
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
              <th scope="col">SITE MANAGER</th>{" "}
              {/* Changed "Site Manager" to "Sites" here */}
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
                  <td>{site.budget}</td>
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

export default Sites; // Updated the export name to "Sites"
