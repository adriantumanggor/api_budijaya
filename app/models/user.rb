class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :password_hash, presence: true
  
    # Setter untuk mengenkripsi password saat disimpan
    def password=(new_password)
      self.password_hash = BCrypt::Password.create(new_password)
    end
  end
  