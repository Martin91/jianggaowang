class UserPasswordsController < ApplicationController
  def reset
  end

  def create_new
    username = params[:user][:name]
    user = User.find_by name: username

    if user
      user.generate_reset_password_token
      UserPasswordMailer.delay.reset_password(user)

      flash[:success] = "重置密码请求成功，我们已经给您发送了用于重置密码的邮件，请注意查收邮件！"
      redirect_to root_path
    else
      flash[:warning] = "用户名不存在，请重新输入"
      render 'reset'
    end
  end

  def edit
  end
end
