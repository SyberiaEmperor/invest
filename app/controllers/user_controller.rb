class UserController < ApplicationController

  def info
    #Получаем токен из Header и делаем магию
    render json: {
      name: "Name",
      id:1,
      hz:nil
    }
  end

end