class Portfolio < ApplicationRecord
  validates_presence_of :id, :user_id
  belongs_to :user
  has_many :transactions
  has_one :storage
end
