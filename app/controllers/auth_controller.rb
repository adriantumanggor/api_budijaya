class AuthController < ApplicationController
    require 'bcrypt'

    def login
      user = User.find_by(username: params[:username])
  
      if user && BCrypt::Password.new(user.password_hash) == params[:password]
        render json: { token: generate_token(user), role: user.role,is_completed: user.attendance_completed_today? }, status: :ok
      else
        render json: { error: 'Invalid username or password' }, status: :unauthorized
      end
    end
  
    private
  
    def generate_token(user)
      payload = { user_id: user.id, karyawan_id: user.karyawan_id, username: user.username, role: user.role, is_completed: user.attendance_completed_today?}
      secret = Rails.application.credentials.secret_key_base
      JWT.encode(payload, secret)
    end
end
