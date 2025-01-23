// Function to wish the user based on the time of the day
function wishUser() {
    const today = new Date();
    const hour = today.getHours();
    let greeting = '';

    if (hour >= 0 && hour < 12) {
        greeting = 'Good Morning!';
    } else if (hour >= 12 && hour < 18) {
        greeting = 'Good Afternoon!';
    } else {
        greeting = 'Good Evening!';
    }

    // Display greeting in an alert
    alert(greeting);
    // Update greeting message on the page
    document.getElementById('greeting').textContent = greeting;
}

// Function to update the clock every second
function updateClock() {
    const today = new Date();
    let hours = today.getHours();
    let minutes = today.getMinutes();
    let seconds = today.getSeconds();

    // Add leading zero if necessary
    hours = (hours < 10 ? '0' : '') + hours;
    minutes = (minutes < 10 ? '0' : '') + minutes;
    seconds = (seconds < 10 ? '0' : '') + seconds;

    const timeString = hours + ':' + minutes + ':' + seconds;

    // Display clock on the webpage
    document.getElementById('clock').textContent = timeString;
}

// Initialize the wish and clock update
window.onload = function() {
    wishUser(); // Wish the user when the page loads
    setInterval(updateClock, 1000); // Update the clock every second
};
