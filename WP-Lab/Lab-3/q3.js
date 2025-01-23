function submit_form() {
    let inputs = Array.from(document.getElementsByTagName('input'));
    let result_div = document.getElementById("result");
    const length = inputs.length;
    let values = inputs.map((input_element) => input_element.value).map(Number);
    const avg = values.reduce((partialSum, a) => partialSum + a, 0) / length;
    console.log(avg);
    let result_string;
    if (avg > 90){
        result_string = "A";
    }
    else if (avg > 80){
        result_string = "B";
    }
    else if (avg > 70){
        result_string = "C";
    }
    else if (avg > 60){
        result_string = "D";
    }
    else{
        result_string = "F";
    }

    if (result_string === "F") {
        result_div.style.color = 'red';
    }
    else {
        result_div.style.color = 'green';
    }

    result_div.innerText = `Grade: ${result_string}`;
    result_div.style.display = 'block';
}