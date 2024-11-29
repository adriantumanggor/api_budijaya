class AuthController < ApplicationController
    require 'bcrypt'

    def login
      user = User.find_by(username: params[:username])
  
      if user && BCrypt::Password.new(user.password_hash) == params[:password]
        render json: { token: generate_token(user), role: user.role }, status: :ok
      else
        render json: { error: 'Invalid username or password' }, status: :unauthorized
      end
    end
  
    private
  
    def generate_token(user)
      payload = { user_id: user.id, role: user.role }
      secret = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
      JWT.encode(payload, secret)
    end
end
