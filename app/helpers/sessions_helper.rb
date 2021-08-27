module SessionsHelper
   # 渡されたユーザーでログインする
   
   #sessionとcookiesの違いとしてcooiesは、画面遷移した際にログインするのがめんどいから覚えてもの。
   #cookiesは、ブラウザを閉じた際でも自動的にログインできるようにする仕組み。
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    #cookies.user.idこんな感じだとセキュリティダメだからcookies.signed[:user_id] = user.idこれに
    #でも２０年間保存したいだから今の形にした。
    cookies.permanent.signed[:user_id] = user.id
    #多分remember_tokenは分かっても意味ないからセキュリティにしてない？
    cookies.permanent[:remember_token] = user.remember_token
  end
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
   # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
   # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
