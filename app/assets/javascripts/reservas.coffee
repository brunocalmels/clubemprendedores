# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $(".franja_horaria").on "click", (event) ->
    hora_inicio = this.dataset.horaInicio
    hora_fin = this.dataset.horaFin
    this.classList.add('elegido')
    setTimeout ->
      $('#reserva_start_time_4i')[0].selectedIndex = hora_inicio
      $('#reserva_end_time_4i')[0].selectedIndex = hora_fin
      $('#reserva_start_time_4i').addClass('elegido')
      $('#reserva_end_time_4i').addClass('elegido')
    , 300
    setTimeout( ->
      $('.elegido').removeClass('elegido')
    , 1500)

  $(".grupos").on "click", (event) ->
    $("#grupos-list").show(1000)

  # Si se hace click en 'Invitados anteriores' ya no se pueden agregar a mano
  $("#invitados .grupos > a:first-child").on "click", (event) ->
    anchor = $('#invitados > .links > a.add_fields')
    if anchor.length > 0
      anchor[0].remove()
    $('#invitados > div.grupos > a').hide()
    $('#invitados > h4').text('Invitados anteriores')

  # Si se agregan a mano, ya no se pueden buscar anteriores
  $('#invitados > .links > a.add_fields').on "click", ->
    anchor = $('#invitados > .grupos > a')
    if anchor.length > 0
      anchor[0].remove()

  # Carga el Id de la reserva cuyos invitados se repetirán
  $('.nombre_grupo').on "click", (event) ->
    $('.nombre_grupo').removeClass('elegido')
    event.target.classList.add('elegido')
    # console.log(event.target.dataset.reservaid)
    $('#invitados_grupo_reserva_id')[0].value = event.target.dataset.reservaid
