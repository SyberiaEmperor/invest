require_relative '../../lib/apis/moex_api'
class TransactionController < ApplicationController
  before_action :authorize_request
  skip_before_action :verify_authenticity_token

  protect_from_forgery with: :null_session
  # Принимает в себя: Ticker, количество, изменение баланса, id портфеля
  def create
    p = @current_user.portfolios.find params[:portfolio_id]
    if p.nil?
      render json: {
        error: "Invalid portfolio's ID"
      }, status: :not_acceptable
    end
    #MoexAPI::Client.init
    ticker = params[:ticker]
    if ticker.nil?
      render json: {
        errors: "Ticker is necessary"
      },
             status: :bad_request
    end
    price = MoexAPI::Client.get_info_by_ticker ticker
    amount = params[:amount].to_i
    if amount.nil?
      render json: {
        errors: "Amount is necessary"
      },
             status: :bad_request
    end
    balance_change = price * amount
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