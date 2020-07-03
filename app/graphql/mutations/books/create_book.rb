# frozen_string_literal: true

module Mutations::Books
  # Base GraphQL mutation class
  class CreateBook < Mutations::BaseMutation
    argument :book, Types::BookInputType, required: true

    # Ths is the type this is gonna return
    type Types::BookType

    def resolve(book:)
      authenticated_user?(:create, Book)
      author = Author.find(book.author_id)
      book = author.books.create!(book.to_h.except(:author_id))
      book
    end

    def self.visible?(context)
      return false unless context[:current_ability].present?
      context[:current_ability].can?(:create, Book)
    end
    # def self.accessible?(context)
    #   return false unless context[:current_ability].present?
    #   context[:current_ability].can?(:create, Book)
    # end
  end
end
