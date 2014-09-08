class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @slides = current_user.slides.page(params[:page]).per(params[:per_page] || 9)
  end

  def edit
  end
end
