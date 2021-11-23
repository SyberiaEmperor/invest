class UserController < ApplicationController
  def info
    p "Bubba"
    render json: {'alpha':1}
  end
end