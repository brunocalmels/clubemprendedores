class ReservaPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    current_user.present? && (
      current_user.admin? || current_user == reserva.user
    )
  end
end
