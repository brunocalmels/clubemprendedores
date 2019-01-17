module ReservasHelper
  def puede_editar?(reserva)
    current_user.present? && (current_user.admin? || (current_user == reserva.user))
  end

  # Devuelve la hora de apertura para ser usada en los forms por defecto
  # @param {string} dia
  def horario_apertura(dia)
    mediodia = Time.zone.parse(dia + " 12:00:00")
    Time.zone.parse(dia + " #{HORAS_APERTURA[mediodia.wday]}:00:00")
  end

  # Devuelve las franjas horarias de un día de la semana
  # @param {string} dia
  def franjas_horarias(dia)
    dia = Time.zone.parse(dia + " 12:00:00") if dia.class == String
    (HORAS_APERTURA[dia.wday]..(HORAS_CIERRE[dia.wday] - 1)).map { |p| [p, p + 1] }
  end

  # Asegura que solo un admin pueda acceder
  def assure_admin!
    return if current_user.admin?

    respond_to do |format|
      format.html { redirect_to(root_path) && (return false) }
      format.json {}
    end
  end
end
