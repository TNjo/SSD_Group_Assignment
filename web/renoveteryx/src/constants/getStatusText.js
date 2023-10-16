// Function to map status numbers to status text
export const getStatusText = (status) => {
    switch (status) {
        case 1:
            return 'Pending';
        case 2:
            return 'Sent to Supplier';
        case 3:
            return 'Sent to Manager';
        case 4:
            return 'Supplier Accepted';
        case 5:
            return 'Supplier Rejected';
        case 6:
            return 'Manager Rejected';
        default:
            return 'Unknown';
    }
};