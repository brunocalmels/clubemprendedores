module ReservasHelper
  def puede_editar?(reserva)
    current_user.present? && (current_user.admin? or current_user == reserva.user)
  end

  # Devuelve la hora de apertura para ser usada en los forms por defecto
  # @param {string} dia
  def horario_apertura(dia)
    d = Time.zone.parse(dia + " #{HORA_APERTURA}:00:00")
  end

  # Asegura que solo un admin pueda acceder
  def assure_admin!
    unless current_user.admin?
      respond_to do |format|
        format.html { redirect_to(root_path) && (return false) }
        format.json {}
      end
    end
  end

end
