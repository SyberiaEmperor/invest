class User < ApplicationRecord
  validates_presence_of :id, :login
  has_many :portfolios
end
