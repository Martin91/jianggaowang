class SlidesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  after_action :increase_slide_visits_count, only: [:show]

  def show
    @slide = Slide.includes(:previews).find(params[:id])
    @category = @slide.category
  end

  def new
    @resource_key = generate_unique_resource_key + '.pdf'
    generate_uptoken @resource_key
  end

  def upload_result
    if (slide = Slide.find_by filename: params[:resource_key])
      flash[:success] = "讲稿#{slide.title}上传成功"
      redirect_to slide
    else
      flash[:danger] = "讲稿上传失败，请尝试重新上传！如有需要，请与管理员hongzeqin@gmail.com联系"
      redirect_to new_slide_path
    end
  end

  def search
    @keyword = params[:keyword]

    if @keyword
      @slides = Slide.where("title like '%#{@keyword}%'").page(params[:page])
    else
      @slides = Slide.page(params[:page])
    end
  end

  private
  def generate_unique_resource_key
    generated_key = random_string
    while Slide.find_by filename: generated_key
      generated_key = random_string
    end

    generated_key
  end

  # return a random string with speficed length, default length is 30
  #
  # Example output:
  #   "DcbxfQMAdGXogHrPmvCL6STy6flUSr"
  def random_string(length = 30)
    o = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    (1..length).map { o[rand(o.length)] }.join
  end

  def generate_uptoken(resource_key)
    host = Rails.application.secrets['host'] || request.env["HTTP_HOST"]
    host = "http://" + host unless host =~ /\Ahttp/

    put_policy = Qiniu::Auth::PutPolicy.new Qiniu::Bucket
    put_policy.return_url = upload_result_slides_url resource_key: resource_key

    put_policy.callback_url = host + slide_uploaded_notifications_path
    put_policy.callback_body = [
      "slide[filename]=$(key)",
      "slide[user_id]=#{current_user.id}",
      "slide[title]=$(x:title)",
      "slide[description]=$(x:description)",
      "slide[downloadable]=$(x:downloadable)",
      "slide[category_id]=$(x:category_id)",
      "mime_type=$(mimeType)"
    ].join('&')

    put_policy.mime_limit = 'application/pdf'

    @uptoken = Qiniu::Auth.generate_uptoken(put_policy)
  end

  def increase_slide_visits_count
    unless request.env["HTTP_USER_AGENT"].match(/\(.*https?:\/\/.*\)/)
      @slide.increase_visits_counter
    end
  end
end
