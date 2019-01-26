$(document).on('turbolinks:load', () => {
    $('.vacantes').on('click', event => {
        event.stopPropagation()
        console.log(event);
        let popup = event.target.nextElementSibling;
        popup.classList.remove('invisible');
    });

    $('.reservas_del_dia_container').on('click', () => {
        event.stopPropagation()
        console.log(event);
        $('.popup_container').addClass('invisible');
    });

    $('.popup_container').on('click', () => {
        event.stopPropagation()
        console.log(event);
        event.target.classList.add('invisible');
    });
})