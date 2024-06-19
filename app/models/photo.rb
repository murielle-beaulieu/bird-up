class Photo < ApplicationRecord
  has_one_attached :img
  has_many :search_results, dependent: :destroy
end
