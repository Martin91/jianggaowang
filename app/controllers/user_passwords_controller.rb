class UserPasswordsController < ApplicationController
  def reset
  end

  def create_new
    username = params[:user][:name]
    user = User.find_by name: username

    if user
      user.generate_reset_password_token
      flash[:success] = "我们已经收到您重置密码的请求，请注意查收邮件！"
      redirect_to root_path
    else
      flash[:warning] = "用户名不存在，请重新输入"
      render 'reset'
    end
  end

  def edit
  end
end
