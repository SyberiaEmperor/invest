require_relative '../../lib/apis/moex_api'
class TransactionController < ApplicationController
  before_action :authorize_request
  skip_before_action :verify_authenticity_token

  protect_from_forgery with: :null_session
  # Принимает в себя: Ticker, количество, изменение баланса, id портфеля
  def create
    begin
    p = @current_user.portfolios.find params[:portfolio_id]
    rescue  ActiveRecord::RecordNotFound
      render json: {
        error: "Invalid portfolio's ID"
      }, status: :not_acceptable
      return
    end
    ticker = params[:ticker]
    if ticker.nil?
      render json: {
        errors: "Ticker is necessary"
      },
             status: :bad_request
      return
    end
    begin
    price = MoexAPI::Client.get_info_by_ticker ticker
    rescue MoexAPI::NoSuchTickerError
      render json: {error: "Invalid ticker provided"}, status: :bad_request
      return
      end
    amount = params[:amount].to_i
    if amount.nil?
      render json: {
        errors: "Amount is necessary"
      },
             status: :bad_request
    end
    balance_change = (-(price * amount) * 100).to_i
    @t = Transaction.create ticker: ticker, amount: amount,balance_change:balance_change, portfolio_id: p.id
    if @t.save
      render json:{id: @t.id,
                   ticker: ticker, amount: amount,balance_change:balance_change, portfolio_id: p.id
      },
             status: :created
    else
      render json: {
        errors: @portfolio.errors.full_messages
      },
             status: :unprocessable_entity
    end
    end

end