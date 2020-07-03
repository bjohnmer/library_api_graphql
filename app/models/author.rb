class Author < ApplicationRecord
  has_many :author_books, dependent: :destroy
  has_many :books, through: :author_books

  validates :first_name, :last_name, :yob, presence: true
  validates :is_alive, inclusion: [true, false]

  def full_name
    ([first_name, last_name].compact).join(' ')
  end
end
