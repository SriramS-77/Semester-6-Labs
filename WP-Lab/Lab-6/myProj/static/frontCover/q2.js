document.getElementById('coverForm').addEventListener('submit', function(e) {
    e.preventDefault();  // Prevent form submission

    // Get values from form inputs
    const coverImage = document.getElementById('coverImage').files[0];
    const backgroundColor = document.getElementById('backgroundColor').value;
    const headlineText = document.getElementById('headlineText').value;
    const headlineFontSize = document.getElementById('headlineFontSize').value;
    const headlineFontColor = document.getElementById('headlineFontColor').value;
    const subheadingText = document.getElementById('subheadingText').value;
    const subheadingFontSize = document.getElementById('subheadingFontSize').value;
    const subheadingFontColor = document.getElementById('subheadingFontColor').value;

    // Set background color
    const cover = document.getElementById('cover');
    cover.style.backgroundColor = backgroundColor;

    // Set image if selected
    if (coverImage) {
        const reader = new FileReader();
        reader.onload = function(e) {
            cover.style.backgroundImage = `url(${e.target.result})`;
        };
        reader.readAsDataURL(coverImage);
    }

    // Set headline text and styles
    const headline = document.getElementById('headline');
    headline.textContent = headlineText || 'Your Headline Here';
    headline.style.fontSize = `${headlineFontSize}px`;
    headline.style.color = headlineFontColor;

    // Set subheading text and styles
    const subheading = document.getElementById('subheading');
    subheading.textContent = subheadingText || 'Your Subheading Here';
    subheading.style.fontSize = `${subheadingFontSize}px`;
    subheading.style.color = subheadingFontColor;
});
