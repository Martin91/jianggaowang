class UsersController < ApplicationController
  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = "注册成功，您现在已登录"
      session[:user_id] = @user.id

      redirect_to root_path
    else
      flash[:warning] = "新用户注册失败"
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
