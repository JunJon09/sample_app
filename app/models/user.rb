class User < ApplicationRecord
  #nameの存在の有無を確認rails console --sandbox
  
  #validatesはデータが本当にそれで良いのかを確認するメソッド
  #presenceはそれが空かどうかを確認している。
  before_save { self.email = email.downcase } #全ての文字を小文字にする。
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length:  { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
  uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  
  has_secure_password
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
end
