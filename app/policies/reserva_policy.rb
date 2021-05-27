# frozen_string_literal: true

class ReservaPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def update?
    user.present? && (
      user.admin? || user == record.user
    )
  end
end
