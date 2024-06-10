class Bird < ApplicationRecord
  has_many :spottings
  has_many :users, through: :spottings
end
