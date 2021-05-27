# frozen_string_literal: true

class GrupoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return nil unless user&.admin?

      scope.all
    end
  end
end
