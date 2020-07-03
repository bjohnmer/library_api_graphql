# frozen_string_literal: true

module Mutations
  module Users
    # Sign In class
    class SignIn < Mutations::BaseMutation
      graphql_name 'SignIn'

      argument :email, String, required: true
      argument :password, String, required: true

      type Types::UserType

      def resolve(args)
        user = authenticate_user(args[:email], args[:password])
        context[:current_user] = user
        user
      end

      private

      def authenticate_user(email, password)
        error = GraphQL::ExecutionError

        user = User.find_for_database_authentication(email: email)

        unless user.present?
          msg = 'User not registered on this application'
          raise error.new(msg)
        end

        msg = 'Incorrect Email/Password'
        raise error.new(msg) unless user.valid_password?(password)

        user
      end
    end
  end
end
