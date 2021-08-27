class User < ApplicationRecord
  
  attr_accessor :remember_token
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
  
  #fixtureというユーザのログインの人を作るために必要なもの
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  #SecureRandom.urlsafe_base64は、ランダムに２２文字の数字を作ってくれるもの。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    #(:remember_digest, User.digest(remember_token) 第一引数に第二引数を代入する？
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
   # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end
