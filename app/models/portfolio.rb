class Portfolio < ApplicationRecord
  validates_presence_of :user_id
  belongs_to :user
  has_many :transactions
  has_one :storage
end
