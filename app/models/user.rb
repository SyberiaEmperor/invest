class User < ApplicationRecord
  has_secure_password
  validates :login, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 4 },
            if: -> { new_record? || !password.nil? }
  has_many :portfolios
end
