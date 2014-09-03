class SlidesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def show
  end
end
