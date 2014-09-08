class Slide < ActiveRecord::Base
  validates :title, :description, :user_id, :filename, presence: true
  has_many :previews, dependent: :destroy
  belongs_to :category
  belongs_to :user

  def persistent_previews
    total_pages = retrieve_total_pages
    watermark_text = Qiniu::Utils.urlsafe_base64_encode("讲稿网：@#{user.name}")
    bucket = Qiniu::Bucket

    pfops = (1..retrieve_total_pages).map do |page|
      target_key = filename.split('.')[0..-2].join('.') + "-#{page}.jpg"

      "odconv/jpg/page/#{page}/density/150/resize/800|" +
      "watermark/2/text/#{watermark_text}/fontsize/500/dissolve/60|" +
      "saveas/#{Qiniu::Utils.encode_entry_uri(bucket, target_key)}"
    end.join(';')

    notify_url = "#{Qiniu::NotificationHost}/notifications/persistance_finished"
    pfop_policy = Qiniu::Fop::Persistance::PfopPolicy.new(bucket, filename, pfops, notify_url)
    pfop_policy.pipeline = Qiniu::MPSQueue

    response = Qiniu::Fop::Persistance.pfop pfop_policy
    persistent_id = response[1]["persistentId"]

    update_column :persistent_id, persistent_id if persistent_id
  end

  def retrieve_total_pages
    uri = URI("http://#{Qiniu::Bucket}.qiniudn.com/#{filename}?odconv/jpg/info")
    response = JSON.parse Net::HTTP.get(uri)
    response["page_num"]
  end
end
