class Transaction < ApplicationRecord
  validates_presence_of :portfolio_id, :ticker, :amount, :balance_change
  belongs_to :portfolio
end
