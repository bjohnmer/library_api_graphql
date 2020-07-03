class Book < ApplicationRecord
  belongs_to :category

  has_many :author_books, dependent: :destroy
  has_many :authors, through: :author_books

  validates :title, :yop, :category, presence: true
end
