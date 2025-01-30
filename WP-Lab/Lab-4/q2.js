const display_bar = $('#disp');

function calc(expression) {
    try {
        var result = eval(expression); // Calculate the result using eval
        return result;
    } catch (error) {
        return "ERROR";
    }
}

$(document).ready(function() {
    // This will add an onclick function to all buttons on the page
    $('button').click(function() {
        var buttonText = $(this).text();  // Get the text of the clicked button
        console.log(buttonText + " button clicked!");
        if (buttonText === "CLR") {
            display_bar.val("");    
        }
        else if (buttonText === "=") {
            let result = calc(display_bar.val());
            display_bar.val(result); 
        }
        else if (buttonText === "x") {
            display_bar.val(display_bar.val() + "*");
        }
        else {
            display_bar.val(display_bar.val() + buttonText);
        }
        display_bar.focus()
    });
});
