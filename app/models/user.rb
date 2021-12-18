class User < ApplicationRecord
  has_secure_password
  validates :login, presence: true, uniqueness: true
  validates :hash,
            length: { minimum: 4 },
            if: -> { new_record? || !hash.nil? }
  has_many :portfolios
end
