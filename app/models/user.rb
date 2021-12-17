class User < ApplicationRecord
  has_secure_password
  validates :login, presence: true, uniqueness: true
  validates_presence_of :id, :login
  has_many :portfolios
end
