class InicioController < ApplicationController
  def index
    @reservas = Reserva.all
  end
end
