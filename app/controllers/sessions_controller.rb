class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password]) #userの情報が入ってるかつそれがあってるかの論理積
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination' #これだと他にページのリクエストが起きた時に消える
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? 
    redirect_to root_url
  end
end
