class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @slides = @category.slides.page(params[:page]).per(params[:per_page])
  end

  def all
    @category = Category.new name: '所有讲稿'
    @slides = Slide.page(params[:page]).per(params[:per_page])
    render 'show'
  end

  def hotest
    @category = Category.new name: '热门讲稿'
    @slides = Slide.hotest.page(params[:page])
    render 'show'
  end
end
