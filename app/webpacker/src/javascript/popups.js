$(document).on('turbolinks:load', () => {
    $('.vacantes').on('click', event => {
        event.stopPropagation()
        let popup = event.target.nextElementSibling;
        popup.classList.remove('invisible');
    });

    $('.reservas_del_dia_container').on('click', () => {
        event.stopPropagation()
        $('.popup_container').addClass('invisible');
    });

    $('.popup_container').on('click', () => {
        event.stopPropagation()
        event.target.classList.add('invisible');
    });
})