let img_status = 'right';

document.getElementById('move-button').addEventListener('click', function() {
    const tableAndImage = document.querySelector('.container');
    
    if (img_status === 'right') {
        img_status = 'left';
        // Reset animation to allow multiple clicks
        tableAndImage.style.transition = 'none';
        tableAndImage.offsetHeight; // Trigger reflow to reset animation
        
        // Start the movement with a transition
        tableAndImage.style.transition = 'transform 2s ease';
        tableAndImage.style.transform = 'translateX(-35%)';
    }
    else {
        img_status = 'right';
        // Reset animation to allow multiple clicks
        tableAndImage.style.transition = 'none';
        tableAndImage.offsetHeight; // Trigger reflow to reset animation
        
        // Start the movement with a transition
        tableAndImage.style.transition = 'transform 2s ease';
        tableAndImage.style.transform = 'translateX(+35%)';
    }
});
