const card = $('#card');
const img = $('img');
const text = $('div.text');
const color_select = $('select.color');
const font_select = $('select.font');
const size_input = $('input.size');
const border_select = $('select.border');
const text_input = $('textarea');
const url_input = $('input.url');


function makeCard() {
    console.log(text_input.val());
    card.css({
        'background-color': color_select.val(),
        'border': border_select.val()
    });
    text.css({
        'font-family': font_select.val(),
        'font-size': size_input.val() + 'px'
    });
    text.text(text_input.val());
    if (url_input.val().trim() === "") {
        return;
    }
    else {
        img.attr('src', url_input.val());
    }
}