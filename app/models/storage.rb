class Storage < ApplicationRecord
  validates_presence_of :id
  belongs_to :portfolio
end
