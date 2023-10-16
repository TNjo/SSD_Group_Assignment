import ProgressBar from 'react-bootstrap/ProgressBar';

export function progressBar(total, budjet) {

    const now = 91;
    let color = "green"; // Default color

    if (now > 90) {
        color = "red"; // Change the color when progress exceeds 90%
    }

    return <ProgressBar className="text-lg font-weight-bold" style={{ backgroundColor: color }} now={now} label={`${now}%`} />;
}

export default progressBar;