$(document).ready(function() {
    $('#produceBillButton').click(function() {
        // Get selected brand
        var selectedBrand = $('#brandDropdown').val();
        
        // Get selected product type (mobile and/or laptop)
        var mobileSelected = $('#mobile').prop('checked');
        var laptopSelected = $('#laptop').prop('checked');

        // Get quantity
        var quantity = $('#quantity').val();
        quantity = parseInt(quantity);

        // Price list for each product
        var prices = {
            hp: { mobile: 500, laptop: 1000 },
            nokia: { mobile: 400, laptop: 900 },
            samsung: { mobile: 600, laptop: 1100 },
            motorola: { mobile: 450, laptop: 950 },
            apple: { mobile: 800, laptop: 1200 }
        };

        // Calculate total amount
        var totalAmount = 0;

        if (mobileSelected) {
            totalAmount += prices[selectedBrand].mobile * quantity;
        }
        if (laptopSelected) {
            totalAmount += prices[selectedBrand].laptop * quantity;
        }

        // Display the total amount in an alert
        alert("Total Amount: $" + totalAmount);
    });
});
