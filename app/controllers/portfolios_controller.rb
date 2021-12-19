class PortfoliosController < ApplicationController
  before_action :authorize_request
  skip_before_action :verify_authenticity_token


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
    all_por = @current_user.portfolios.all
    json_data = all_por.map do |portf|
      portf.as_json
    end
    render json: json_data
  end


  #Создаёт портфель. Возвращает id созданного портфеля в случае успеха.
  def create
    title = params[:title]
    if title.nil?
      "DefaultName"
    end
    @portfolio=Portfolio.new(user_id:@current_user.id, title:title)
    if @portfolio.save
    render json:{id: @portfolio.id},
      status: :created
    else
      render json: {
        errors: @portfolio.errors.full_messages
      },
            status: :unprocessable_entity
    end
end

  #Удаляет портфель по заданному id. Если id = nil - ничего не происходит.
  def delete

  end



end