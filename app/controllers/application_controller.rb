class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  I18n.locale = :es
end
