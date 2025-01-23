function submit () {
    let score = 0;
    let radio_value = document.querySelector('input[name="q1"]:checked').value;
    if (radio_value === "Mars")
        score++;
    radio_value = document.querySelector('input[name="q2"]:checked').value;
    if (radio_value === "Jawaharlal Nehru")
        score++;
    radio_value = document.querySelector('input[name="q3"]:checked').value;
    if (radio_value === "All of the above")
        score++;
    radio_value = document.querySelector('input[name="q4"]:checked').value;
    if (radio_value === "NaHCO3")
        score++;
    radio_value = document.querySelector('input[name="q5"]:checked').value;
    if (radio_value === "Pirhana")
        score++;

    let result_div = document.getElementById("result");
    let result_string;
    if (score < 3){
        result_string = "Fail";
        result_div.style.backgroundColor = 'red';
    }
    else {
        result_string = "Pass";
        result_div.style.backgroundColor = 'green';  
    }
    result_div.innerText = `Score: ${score}/5. ${result_string}!!!`;
    result_div.style.display = 'block';
}