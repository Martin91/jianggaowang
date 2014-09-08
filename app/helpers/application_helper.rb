module ApplicationHelper
  def resource_url(filename)
    "http://#{Qiniu::Bucket}.qiniudn.com/#{filename}"
  end
end
