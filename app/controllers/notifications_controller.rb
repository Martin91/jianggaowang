class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_qiniu_request

  def slide_uploaded
    slide = Slide.new params[:slide].permit!
    if slide.save
      render json: {status: 'success', slide: slide}
    else
      render json: {status: 'failed', errors: slide.errors}
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
