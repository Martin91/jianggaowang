class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @slides = @category.slides.page(params[:page]).per(params[:per_page])
  end
end
