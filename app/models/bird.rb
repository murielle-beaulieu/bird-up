class Bird < ApplicationRecord
  has_many :spottings
  has_many :users, through: :spottings
  has_many :search_result_birds, dependent: :destroy
end
