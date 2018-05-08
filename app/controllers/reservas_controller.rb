class ReservasController < ApplicationController
  before_action :set_reserva, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[edit new destroy update create index]
  before_action :bloquear_solo_admins, only: %i[create update]

  # GET /reservas
  # GET /reservas.json
  def index
    @reservas = current_user.reservas
  end

  # GET /reservas/1
  # GET /reservas/1.json
  def show; end

  # GET /reservas/new
  def new
    @date = params[:date] || Time.zone.now
    @reserva = Reserva.new(start_time: @date, end_time: @date)
    @reservas = Reserva.del_dia(@reserva)
    @grupos = current_user.reservas.order('created_at DESC').last(3).map { |reserva| {
      nombres: reserva.nombre_invitados,
      reserva_id: reserva.id
      }
    }
  end

  # GET /reservas/1/edit
  def edit
    @reservas = Reserva.del_dia(@reserva)
    @grupos = current_user.reservas.order('created_at DESC').last(3).map { |reserva| {
      nombres: reserva.nombre_invitados,
      reserva_id: reserva.id
      }
    }
  end

  # POST /reservas
  # POST /reservas.json
  def create
    @reserva = Reserva.new(reserva_params)
    @reserva.user = current_user

    # Chequea que no teanga más reservas que el máximo
    if reserva_params[:invitados_attributes].to_h.count > MAX_OCUPACIONES
      @reserva.errors.add(:invitaciones, "No puede haber más de #{MAX_OCUPACIONES} lugares ocupados.")
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reserva.errors, status: :unprocessable_entity }
      end
    else
      byebug
      respond_to do |format|
        if @reserva.save
          if current_user.admin?
            invitados_anon = [params[:invitados_anon].to_i, MAX_OCUPACIONES].min
            @reserva.save
            if invitados_anon > 0
              invitados_anon.times do |invitado_anon|
                @reserva.invitados.create(anonimo: true)
              end
            end
          end

          # Copia invitados de reserva a copiar
          if !params[:invitados_grupo_reserva_id].nil? && params[:invitados_grupo_reserva_id].to_i != 0  && reserva_repe = Reserva.find(params[:invitados_grupo_reserva_id])
            reserva_repe.invitados.each do |invitado|
              @reserva.invitados << invitado.dup
            end
          end

          format.html { redirect_to @reserva, notice: 'La reserva se creó correctamente.' }
          format.json { render :show, status: :created, location: @reserva }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @reserva.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /reservas/1
  # PATCH/PUT /reservas/1.json
  def update
    if current_user.admin?
      invitados_anon = [params[:invitados_anon].to_i, MAX_OCUPACIONES].min
      if invitados_anon > 0
        @reserva.invitados.delete_all
        byebug
        invitados_anon.times do |invitado_anon|
          @reserva.invitados.create(anonimo: true)
        end
      end
    end

    # Chequear que solo puedan editar reservas los dueños
    if current_user == @reserva.user || current_user.admin?
      if reserva_params[:invitados_attributes].to_h.count > MAX_OCUPACIONES
        @reserva.errors.add(:invitaciones, "No puede haber más de #{MAX_OCUPACIONES} lugares ocupados.")
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity
           }
          format.json { render json: @reserva.errors, status: :unprocessable_entity }
        end
      else
        respond_to do |format|
          if @reserva.update(reserva_params)
            format.html { redirect_to @reserva, notice: 'La reserva fue correctamente guardada.' }
            format.json { render :show, status: :ok, location: @reserva }
          else
            format.html { render :edit, status: :unprocessable_entity
             }
            format.json { render json: @reserva.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'No tiene los permisos necesarios', status: :unauthorized }
        format.json { render :show, status: :unauthorized, location: @reserva }
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

  def bloquear_solo_admins
    if !current_user.admin?
      params[:reserva][:bloqueo] = false
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_reserva
    @reserva = Reserva.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reserva_params
    params.require(:reserva).permit(:end_time, :start_time, :bloqueo, :finalidad, :bloqueo, :invitados_grupo_reserva_id, invitados_attributes: %i[id nombre apellido dni email _destroy])
  end
end
