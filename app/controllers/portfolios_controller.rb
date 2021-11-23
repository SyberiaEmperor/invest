class PortfoliosController < ApplicationController
  @available_currency = [
    :RUB,
    :EUR,
    :USD
  ]
  @default_currency = @available_currency.first

  def show
    if _empty_token
      head :unauthorized
      return
    end
    display_currency = params[:currency]
    display_currency = @default_currency unless @available_currency.include? display_currency
    id = params[:id]
    render json:{
      currency: display_currency,
      id: id,
      info: "There's ur info, sir!"
    }
  end

  def index
    if _empty_token
      head :unauthorized
      return
    end
    display_currency = params[:currency]
    display_currency = @default_currency unless @available_currency.include? display_currency
    render json:{
      currency: display_currency,
      id: id,
      info: "There's ur info, sir!"
    }
  end
  #Создаёт портфель. Возвращает id созданного портфеля в случае успеха.
  # Принимает в себя: ISIN/Ticker, количество, дату совершения(нет, но, вероятно, в будущем. Пока что дата - всегда сегодняшний день)
  # Если id = nil, то создаётся портфель. В противном случае - транзакция записывается в уже существующий портфель
  def create
    if _empty_token
      head :unauthorized
      return
    end
    #creating transaction
    p @_response_body
    portfolio = 1
    render json:{
      id:params[:id],
      portfolio_id: portfolio
    }
end

  #Удаляет портфель по заданному id. Если id = nil - ничего не происходит.
  def delete
    if _empty_token
      head :unauthorized
      return
    end
    head :ok
  end

  def _empty_token
    token = request.headers[:Authorization]
    token.to_s.empty?

  end

end