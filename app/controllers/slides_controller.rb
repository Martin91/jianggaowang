class SlidesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def show
  end

  def new
    host = Rails.application.secrets['host'] || request.env["HTTP_HOST"]
    host = "http://" if host.index('http') != 0

    put_policy = Qiniu::Auth::PutPolicy.new Qiniu::Bucket
    put_policy.callback_url = host + slide_uploaded_notifications_path
    put_policy.callback_body = [
      "slide[filename]=$(fname)",
      "slide[user_id]=#{current_user.id}",
      "slide[title]=$(x:title)",
      "slide[description]=$(x:description)",
      "slide[downloadable]=$(x:downloadable)",
      "slide[category_id]=$(x:category_id)"
    ].join('&')

    @uptoken = Qiniu::Auth.generate_uptoken(put_policy)
  end

  def uploaded

  end
end
