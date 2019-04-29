# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  # Selección de hora con un click
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


  # Habilita el botón de Crear Reserva sólo cuando se aceptaron las condiciones
  $('#condiciones').on "click", (event) ->
    if (event.target.checked)
      $('#boton_crear_reserva').attr('disabled', false)
    else
      $('#boton_crear_reserva').attr('disabled', true)


  # De acuerdo al tipo de evento, cambia el tipo de invitados (anón o declarados)
  $('select#reserva_finalidad').on "change", (event) ->
    if (event.target.value == "Evento/capacitación/reunión")
      console.log('Evento/capacitacion')
      $('#invitados_anonimos').show(500)
      $('#invitados').hide(500)
    else
      console.log('Co-working')
      $('#invitados').show(500)
      $('#invitados_anonimos').hide(500)
      $('#invitados_anonimos input#invitados_anon').val(0)