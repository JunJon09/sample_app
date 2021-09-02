class User < ApplicationRecord
  
  attr_accessor :remember_token, :activation_token
  #validatesはデータが本当にそれで良いのかを確認するメソッド
  #presenceはそれが空かどうかを確認している。
  before_save :downcase_email #全ての文字を小文字にする。
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length:  { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
  uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
   # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  
end
