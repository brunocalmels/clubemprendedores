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
