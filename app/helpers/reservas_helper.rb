module ReservasHelper
  # Devuelve el array de integers de horas de apertura correspondientes al grupo
  def horas_apertura
    return current_user.grupo.start_times if current_user && !current_user.grupo.nil?

    HORAS_APERTURA
  end

  # Devuelve el array de integers de horas de apertura correspondientes
  def horas_cierre
    return current_user.grupo.end_times if current_user && !current_user.grupo.nil?

    HORAS_CIERRE
  end

  # Devuelve la hora de apertura para ser usada en los forms por defecto
  # @param {string} dia
  def horario_apertura(dia)
    mediodia = Time.zone.parse(dia + " 12:00:00")
    Time.zone.parse(dia + " #{horas_apertura[mediodia.wday]}:00:00")
  end

  # Devuelve las franjas horarias de un día de la semana
  # @param {string} dia
  def franjas_horarias(dia)
    dia = Time.zone.parse(dia + " 12:00:00") if dia.class == String
    (horas_apertura[dia.wday]..(horas_cierre[dia.wday] - 1)).map { |p| [p, p + 1] }
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
