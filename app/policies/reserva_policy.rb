class ReservaPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user.present? && (
      user.admin? || user == record.user
    )
  end
end
