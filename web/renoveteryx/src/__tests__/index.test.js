import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import SiteForm from "../pages/AddSites/SiteForm";

describe("SiteForm Component", () => {
  // Test case to check if the form renders without errors
  it("should render the form without errors", () => {
    render(<SiteForm />);
    expect(screen.getByText("Add Construction Site")).toBeInTheDocument();
  });

  // Test case to check form validation
  it("should display validation errors when submitting an empty form", () => {
    render(<SiteForm />);
    const submitButton = screen.getByText("Add Site");
    fireEvent.click(submitButton);

    // Check that validation errors are displayed for each input field
    expect(screen.getByText("ID is required")).toBeInTheDocument();
    expect(screen.getByText("Name is required")).toBeInTheDocument();
    expect(screen.getByText("Location is required")).toBeInTheDocument();
    expect(screen.getByText("Site Manager is required")).toBeInTheDocument();
    expect(
      screen.getByText("Budget must be greater than 0")
    ).toBeInTheDocument();
  });

  // Test case to check successful form submission
  it("should submit the form successfully", () => {
    render(<SiteForm />);
    const idInput = screen.getByTestId("id-input");
    const nameInput = screen.getByTestId("name-input");
    const locationInput = screen.getByTestId("location-input");
    const siteManagerSelect = screen.getByTestId("sitemanager-select");
    const budgetInput = screen.getByTestId("budget-input");
    const submitButton = screen.getByText("Add Site");

    // Fill in the form fields
    fireEvent.change(idInput, { target: { value: "123" } });
    fireEvent.change(nameInput, { target: { value: "Sample Site" } });
    fireEvent.change(locationInput, { target: { value: "Sample Location" } });
    fireEvent.change(siteManagerSelect, {
      target: { value: "Sample Manager" },
    });
    fireEvent.change(budgetInput, { target: { value: "10000" } });

    // Submit the form
    fireEvent.click(submitButton);
  });
});
