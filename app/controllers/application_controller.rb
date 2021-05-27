# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  I18n.locale = :es

  # Asegura que solo un admin pueda acceder
  def assure_admin!
    return if current_user&.admin?

    respond_to do |format|
      format.html { redirect_to(root_path) && (return false) }
      format.json {}
    end
  end
end
