class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :birds, through: :spottings
  has_many :spottings
  has_many :search_results, dependent: :destroy
  validates :username, presence: true
end
