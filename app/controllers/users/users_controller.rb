# frozen_string_literal: true

module Users
  class UsersController < ApplicationController
    before_action :assure_admin!, only: %i[show]

    def show
      @user = User.find(params[:id])
      render "users/show"
    end
  end
end
