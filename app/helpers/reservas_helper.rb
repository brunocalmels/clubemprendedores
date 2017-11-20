module ReservasHelper
  def puede_editar?(reserva)
    current_user.present? && (current_user.admin? or current_user == reserva.user)
  end
end
