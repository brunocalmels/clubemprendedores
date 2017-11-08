module ReservasHelper
  def puede_editar?(reserva)
    # TODO: Incluir modelo de admin
    # current_admin or
    current_user == reserva.user
  end
end
