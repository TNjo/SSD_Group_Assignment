import React from 'react';
import ProgressBar from 'react-bootstrap/ProgressBar';

const progressBar = (budget, overallTotal) => {

    // const percentage = 6500;
    const percentage = overallTotal / budget * 100;
    const label = `${percentage.toFixed(2)}%`

    const getProgressBarVariant = () => {
        if (percentage <= 25) return 'success';
        if (percentage <= 50) return 'info';
        if (percentage <= 75) return 'warning';
        return 'danger';
    };

    return (
        <ProgressBar
            now={percentage}
            variant={getProgressBarVariant()}
            label={label}
            style={{ backgroundColor: '#9fc5e8', height: '20px' }}
        />
    );
};

export default progressBar;