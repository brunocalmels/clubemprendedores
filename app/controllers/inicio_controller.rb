# frozen_string_literal: true

class InicioController < ApplicationController
  before_action :assure_admin!, only: %i[docs]

  # GET /
  def index
    @reservas = Reserva.all
  end

  # GET /docs
  def docs; end
end
