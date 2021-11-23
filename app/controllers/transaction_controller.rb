class TransactionController < ApplicationController

  def delete
    #Получаем токен из Header и делаем магию
    token = request.headers[:Authorization]
    if token.to_s.empty?
      head :unauthorized
      return
    end
    head :ok
  end

end