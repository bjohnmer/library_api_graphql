class User < ApplicationRecord
  include GraphQL::Interface

  devise :database_authenticatable, :token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :token_authenticatable, :trackable

  enum role: %w[user admin]
  validates :first_name, :last_name, presence: true
end
