module Api
	class Api::ApplicationController < ApplicationController

		prepend_before_action :authenticate_user_from_token!

		private

		def authenticate_user_from_token!
			user_email = params[:user_email].presence
			user = user_email && User.find_by(email: user_email)
			if user && Devise.secure_compare(user.authentication_token, params[:user_token])
				sign_in user, store: true
			else
				render json: { status: "auth failed" }
				false
			end
		end
	end
end