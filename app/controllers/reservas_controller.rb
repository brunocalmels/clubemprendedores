class ReservasController < ApplicationController
  before_action :set_reserva, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[edit new destroy update create]

  # GET /reservas
  # GET /reservas.json
  def index
    @reservas = Reserva.all
  end

  # GET /reservas/1
  # GET /reservas/1.json
  def show; end

  # GET /reservas/new
  def new
    @reserva = Reserva.new(start_time: params[:date], end_time: params[:date])
    # @reserva.build_invitado
  end

  # GET /reservas/1/edit
  def edit; end

  # POST /reservas
  # POST /reservas.json
  def create
    @reserva = Reserva.new(reserva_params)
    @reserva.user = current_user

    respond_to do |format|
      if @reserva.save
        format.html { redirect_to @reserva, notice: 'Reserva was successfully created.' }
        format.json { render :show, status: :created, location: @reserva }
      else
        format.html { render :new }
        format.json { render json: @reserva.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservas/1
  # PATCH/PUT /reservas/1.json
  def update
    respond_to do |format|
      if @reserva.update(reserva_params)
        format.html { redirect_to @reserva, notice: 'La reserva fue correctamente guardada.' }
        format.json { render :show, status: :ok, location: @reserva }
      else
        format.html { render :edit }
        format.json { render json: @reserva.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservas/1
  # DELETE /reservas/1.json
  def destroy
    @reserva.invitados.delete_all
    @reserva.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'La reserva fue correctamente eliminada.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reserva
    @reserva = Reserva.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reserva_params
    params.require(:reserva).permit(:end_time, :start_time, invitados_attributes: %i[id nombre apellido dni email _destroy])
  end
end
