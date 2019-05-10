# rubocop:disable Metrics/ClassLength
class ReservasController < ApplicationController
  include ReservasHelper
  before_action :set_reserva, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[edit new destroy update create index esperando_aprobacion]
  before_action :bloquear_solo_admins, only: %i[create update]
  before_action :assure_admin!, only: %i[esperando_aprobacion]

  # GET /reservas
  # GET /reservas.json
  def index
    @reservas = policy_scope(Reserva)
    respond_to do |format|
      format.html do
        @reservas = @reservas.page params[:page]
      end
      format.xls {}
    end
  end

  # GET /reservas/1
  # GET /reservas/1.json
  def show; end

  # GET /reservas/new
  # rubocop:disable Metrics/AbcSize
  def new
    if params[:date]
      @date = params[:date] || Time.zone.now
      @reserva = Reserva.new(start_time: horario_apertura(@date), end_time: horario_apertura(@date) + 1.hour)
    else
      @reserva = Reserva.new(start_time: Time.zone.today.noon, end_time: Time.zone.today.noon + 1.hour)
    end
    @reserva.user = current_user
    buscar_reservas_dia
  end

  # GET /reservas/1/edit
  def edit
    redirect_to(@reserva) && return unless @reserva.start_time > Time.zone.now
    @reservas = Reserva.del_dia(@reserva)
    @grupos = current_user.reservas.no_anonimas.order('reservas.created_at DESC').last(3).map do |reserva|
      {
        nombres: reserva.nombre_invitados,
        reserva_id: reserva.id
      }
    end
  end
  # rubocop:enable Metrics/AbcSize

  # POST /reservas
  # POST /reservas.json
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def create
    @reserva = Reserva.new(reserva_params)
    decide_aprobacion(@reserva)
    @reserva.user = current_user
    @date = @reserva.start_time

    # Chequea que no tenga más reservas que el máximo
    if reserva_params[:invitados_attributes].to_h.size > MAX_OCUPACIONES
      @reserva.errors.add(:invitaciones, "No puede haber más de #{MAX_OCUPACIONES} lugares ocupados.")
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reserva.errors, status: :unprocessable_entity }
      end
    else
      # rubocop:disable Metrics/BlockLength
      respond_to do |format|
        if @reserva.save
          notice_admins_create
          if @reserva.finalidad == "Evento/capacitación/reunión" || current_user.admin?
            invitados_anon = [params[:invitados_anon].to_i, MAX_OCUPACIONES].min
            @reserva.save
            invitados_anon.times do |_invitado_anon|
              @reserva.invitados.create(anonimo: true)
            end
            # Copia invitados de reserva a copiar
          elsif !params[:invitados_grupo_reserva_id].nil? && params[:invitados_grupo_reserva_id].to_i != 0 && (reserva_repe = Reserva.find(params[:invitados_grupo_reserva_id]))
            reserva_repe.invitados.each do |invitado|
              @reserva.invitados << invitado.dup
            end
          end
          format.html do
            if params[:y_nueva].nil?
              redirect_to @reserva, notice: 'La reserva se creó correctamente.'
            else
              redirect_to new_reserva_path(date: @reserva.start_time), notice: 'La reserva se creó correctamente.'
            end
          end
          format.json { render :show, status: :created, location: @reserva }
        else
          format.html do
            @date = @reserva.start_time
            buscar_reservas_dia
            render :new, status: :unprocessable_entity
          end
          format.json { render json: @reserva.errors, status: :unprocessable_entity }
        end
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def notice_admins_create
    return if current_user.admin?

    @link = reserva_url(@reserva)
    if @reserva.aprobado
      @subject = "Reserva de turno"
      @text =  "#{@reserva.user.nombre_completo} ha reservado el Club desde el #{@reserva.start_time.strftime('%e %b %H:%M hs')} hasta el #{@reserva.end_time.strftime('%e %b %H:%M hs')}"
    else
      @subject = "Reserva de turno - Necesita aprobación"
      @text = "#{@reserva.user.nombre_completo} ha reservado el Club desde el #{@reserva.start_time.strftime('%e %b %H:%M hs')} hasta el #{@reserva.end_time.strftime('%e %b %H:%M hs')}. La reserva requiere de aprobación por parte de un administrador."
    end
    AdminMailer.with(
      subject: @subject,
      text: @text,
      link: @link
    ).email_notificacion.deliver_later
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /reservas/1
  # PATCH/PUT /reservas/1.json
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def update
    # Chequear que solo puedan editar reservas los dueños
    if current_user == @reserva.user || current_user.admin?

      # Arregla invitados anonimos
      if reserva_params[:finalidad] == "Evento/capacitación/reunión" || current_user.admin?
        invitados_anon = [params[:invitados_anon].to_i, MAX_OCUPACIONES].min
        if invitados_anon > 0
          @reserva.invitados.delete_all
          invitados_anon.times do |_invitado_anon|
            @reserva.invitados.create(anonimo: true)
          end
          # Remueve parametros de invitados declarados
          params.require(:reserva).delete(:invitados_attributes)
        end
      end

      # Chequea numero de usuarios
      if reserva_params[:invitados_attributes].to_h.size > MAX_OCUPACIONES
        @reserva.errors.add(:invitaciones, "No puede haber más de #{MAX_OCUPACIONES} lugares ocupados.")
        respond_to do |format|
          format.html do
            render :edit, status: :unprocessable_entity
          end
          format.json { render json: @reserva.errors, status: :unprocessable_entity }
        end
      else
        respond_to do |format|
          # Setea aprobación
          decide_aprobacion(@reserva) unless current_user.admin?
          @por_aprobar = !@reserva.aprobado

          if @reserva.update(reserva_params)
            # Arregla invitados previamente anonimos ahora declarados
            @reserva.invitados.each do |inv|
              inv.update anonimo: false
            end

            # Avisa a admins
            notice_admins_update

            format.html { redirect_to @reserva, notice: 'La reserva fue correctamente guardada.' }
            format.json { render :show, status: :ok, location: @reserva }
          else
            format.html do
              render :edit, status: :unprocessable_entity
            end
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
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  # rubocop:disable Metrics/AbcSize
  def notice_admins_update
    if !current_user.admin?
      AdminMailer.with(subject: "Reserva de turno", text: "#{@reserva.user.nombre_completo} ha actualizado su reserva del Club.", link: reserva_url(@reserva)).email_notificacion.deliver_later
    elsif @por_aprobar && @reserva.aprobado
      AdminMailer.with(to: @reserva.user.email, subject: "Turno aprobado", text: "#{current_user.nombre_completo} ha aprobado tu reserva en el Club.", link: reserva_url(@reserva)).email_notificacion.deliver_later
    end
  end
  # rubocop:enable Metrics/AbcSize

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

  # GET /reservas/esperando_aprobacion
  # GET /reservas/esperando_aprobacion.json
  def esperando_aprobacion
    @reservas = Reserva.esperando_aprobacion
    respond_to do |format|
      format.html do
        params[:title] = "Reservas esperando aprobación"
        @reservas = @reservas.page params[:page]
        render :index
      end
      format.json { render json: @reservas }
    end
  end

  private

  # Setea la aprobación por defecto o no, según las políticas
  def decide_aprobacion(reserva)
    # Si es de eventos/capacitacion, no se aprueba por defecto
    reserva.aprobado = false if reserva.finalidad == 'Evento/capacitación/reunión'
    reserva.aprobado = true if current_user.admin?
  end

  # Usado para buscar las reservas de ese día en new y create.
  def buscar_reservas_dia
    @reservas = Reserva.del_dia(@reserva)
    @grupos = current_user.reservas.no_anonimas.order('reservas.created_at DESC').last(3).map do |reserva|
      {
        nombres: reserva.nombre_invitados,
        reserva_id: reserva.id
      }
    end
  end

  def bloquear_solo_admins
    params[:reserva][:bloqueo] = false unless current_user.admin?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_reserva
    @reserva = Reserva.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reserva_params
    if current_user.admin?
      params.require(:reserva).permit(:end_time, :start_time, :bloqueo, :finalidad, :bloqueo, :invitados_grupo_reserva_id, :nombre, :descripcion, :aprobado, invitados_attributes: %i[id nombre apellido dni email _destroy])
    else
      params.require(:reserva).permit(:end_time, :start_time, :bloqueo, :finalidad, :bloqueo, :invitados_grupo_reserva_id, :nombre, :descripcion, invitados_attributes: %i[id nombre apellido dni email _destroy])
    end
  end
end
# rubocop:enable Metrics/ClassLength
