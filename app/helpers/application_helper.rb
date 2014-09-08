module ApplicationHelper
  def resource_url(filename)
    "http://#{Qiniu::Bucket}.qiniudn.com/#{filename}"
  end

  def slide_first_or_default_preview_url(slide)
    if slide.previews.any?
      resource_url slide.previews.first.filename
    else
      image_path 'default_preview.gif'
    end
  end
end
