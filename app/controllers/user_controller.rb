class UserController < ApplicationController
  before_action :authorize_request

  def info
   render json: {
     login: @current_user.login,
     portfolios_count: @current_user.portfolios.count
   }
  end

end