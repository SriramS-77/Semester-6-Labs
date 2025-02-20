// Function to switch pages based on the page name
function showPage(page) {
    console.log("Change Page!!!");
    // Hide all pages
    const pages = document.querySelectorAll('.page');
    pages.forEach(page => {
        page.style.display = 'none';
    });

    // Show the selected page
    if (page === 'metadata') {
        document.getElementById('metadataPage').style.display = 'block';
    } else if (page === 'reviews') {
        document.getElementById('reviewsPage').style.display = 'block';
    } else if (page === 'publisher') {
        document.getElementById('publisherPage').style.display = 'block';
    }
}

// Function to go back to the home page
function goBackToHome() {
    const pages = document.querySelectorAll('.page');
    pages.forEach(page => {
        page.style.display = 'none';
    });
    document.getElementById('homePage').style.display = 'block';
}
