class ApplicationController < ActionController::API
  before_action :sign_in_out!

  private
    def sign_in_out!
      user = User.find_by_email(request.headers['Email'])

      return nil if user.nil?

      user_authenticated = Devise.secure_compare(
        user.authentication_token,
        request.headers['Authorization']
      )

      if params[:query].include? 'signOut'
        user.update(authentication_token: Devise.friendly_token)
      end

      if user_authenticated
        sign_in user
        return
      end

      sign_out user if user_signed_in?
    end

    def current_ability
      return unless current_user
      Ability.new(current_user)
    end
end
