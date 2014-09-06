class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_qiniu_request

  def slide_uploaded
    slide = Slide.new params[:slide].permit!
    if slide.save
      flash[:success] = "讲稿#{slide.title}上传完成，正在进行处理中！"
      redirect_to slide_path(slide)
    else
      flash[:danger] = "讲稿上传失败，失败原因：#{slide.errors}"
      redirect_to new_slide_path
    end
  end

  private
  def verify_qiniu_request
    render nothing: true, status: 403 and return false unless is_qiniu_callback
  end

  def is_qiniu_callback
    authorization_header = request.headers['Authorization']

    return false unless authorization_header && authorization_header.index("QBox").zero?

    remote_token = authorization_header[5..-1]
    access_token = Qiniu::Auth.generate_acctoken request.url, request.body.read
    return false unless remote_token == access_token

    true
  end
end
