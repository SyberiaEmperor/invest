class TransactionController < ApplicationController
  before_action :authorize_request
  skip_before_action :verify_authenticity_token

  protect_from_forgery with: :null_session
  # Принимает в себя: Ticker, количество, изменение баланса, id портфеля
  def create
    p = Portfolio.find(params[:portfolio_id])
    if p.nil?
      render json: {
        error: "Invalid portfolio's ID"
      }, status: :not_acceptable
    end
    @t = Transaction.create(ticker: params[:ticker], amount: params[:amount],balance_change:params[:balance_change], portfolio_id: p.id )
    if @t.save
      render json:{id: @t.id},
             status: :created
    else
      render json: {
        errors: @portfolio.errors.full_messages
      },
             status: :unprocessable_entity
    end
    end

end