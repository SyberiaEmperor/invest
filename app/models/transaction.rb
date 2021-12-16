class Transaction < ApplicationRecord
  validates_presence_of :id, :portfolio_id
  belongs_to :portfolio
end
