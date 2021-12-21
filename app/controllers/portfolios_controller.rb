class String
  def is_integer?
    self.to_i.to_s == self
  end
end

class PortfoliosController < ApplicationController
  before_action :authorize_request
  skip_before_action :verify_authenticity_token


  @@default_currency = "RUB"

  def show
    currency = params[:currency]
    currency = @@default_currency if currency.nil?
    cur_per_rub = currency == "RUB" ? 1 :MoexAPI::Client.get_currency_pair(currency)
    id = params[:id]
    unless id.is_integer?
      render json: {
        error: "Id must be an integer value"
      },
             status: :bad_request
    end
    begin
    port = @current_user.portfolios.find(id)
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: "No such portfolio"
      }, status: :not_found
      return
      end

    if port.nil?
      render json: {error: "No such portfolio"}, status: :not_found
      return
    end
    json_data = port.as_json(:include =>
                               [:transactions, :storages] )
    json_data[:currency] = currency
    json_data[:value] = 0
    port.storages.each { |storage|
      json_data[:value]+=(((MoexAPI::Client.get_info_by_ticker(storage.ticker)*storage.amount)/cur_per_rub)*100).to_i
    }
    render json: json_data
  end

  def index
    currency = params[:currency]
    currency = @@default_currency if currency.nil?
    begin
    cur_per_rub = currency == "RUB" ? 1 :MoexAPI::Client.get_currency_pair(currency)
    rescue MoexAPI::NoSuchCurrencyPair
      render json: {
        error: "Invalid currency"
      }, status: :bad_request
      return
      end
    all_por = @current_user.portfolios.all
    json_data = all_por.map do |portf|
      res = portf.as_json :include => {:storages => {:except => [:portfolio_id, :id]}}
      res[:currency] = currency
      res[:total_cost] = 0
      portf.storages.each { |storage|
        res[:total_cost]+=(((MoexAPI::Client.get_info_by_ticker(storage.ticker)*storage.amount)/cur_per_rub)*100).to_i
      }
      res
    end
    render json: json_data
  end


  #Создаёт портфель. Возвращает id созданного портфеля в случае успеха.
  def create
    title = params[:title].to_s
    title = "DefaultName" if title == ""

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
    begin
      port = @current_user.portfolios.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: "No such portfolio"
      }, status: :not_found
      return
    end

    port.transactions.destroy_all
    port.storages.destroy_all
    port.destroy
    render json: {message: 'Portfolio successfully deleted'},
           status: :ok
  end



end