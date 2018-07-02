module ReservasHelper
  def puede_editar?(reserva)
    current_user.present? && (current_user.admin? or current_user == reserva.user)
  end

  # Devuelve la hora de apertura para ser usada en los forms por defecto
  # @param {string} dia
  def horario_apertura(dia)
    d = Time.zone.parse(dia + " #{HORA_APERTURA}:00:00")
  end
  
end
