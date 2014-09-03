class SlidesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def show
  end

  def new
    put_policy = Qiniu::Auth::PutPolicy.new Qiniu::Bucket
    put_policy.callback_url = request.env["HTTP_HOST"] + qiniu_upload_callback_slides_path
    put_policy.callback_body = [
      "slide[filename]=$(fname)",
      "slide[user_id]=#{current_user.id}",
      "slide[title]=$(x:title)",
      "slide[description]=$(x:description)",
      "slide[downloadable]=$(x:downloadable)"
    ].join('&')

    @uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    @resource_key = Time.now.to_i  # use timestamp as resource_key
  end
end
