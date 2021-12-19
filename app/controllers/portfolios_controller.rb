class String
  def is_integer?
    self.to_i.to_s == self
  end
end

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
    id = params[:id]
    unless id.is_integer?
      render json: {
        error: "Id must be an integer value"
      },
             status: :bad_request
    end
    port = @current_user.portfolios.find(id)
    if port.nil?
      render status: :not_found
    end
    jsonData = port.as_json(:include =>
      :transactions )
    render json: jsonData
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