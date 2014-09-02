class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if (@user = User.find_by name: params[:user].try(:[], :name))
      if @user.authenticate(params[:user].try(:[], :password))
        flash[:success] = "登录成功"
        session[:user_id] = @user.id

        redirect_to root_path
      else
        flash[:danger] = "密码错误，请重新输入"
        render 'new'
      end
    else
      @user = User.new
      flash[:danger] = "用户名不存在，请重新确认您的输入"
      render 'new'
    end
  end

  def destroy
    if current_user
      session[:user_id] = nil
      flash[:success] = "您已退出登录"
    else
      flash[:danger] = '您还没有登录，退出登录操作无效'
    end

    redirect_to :back
  end
end