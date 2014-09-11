class HomeController < ApplicationController
  def index
    @featured_categories = Category.order(slides_count: :desc).limit(3)
  end
end
