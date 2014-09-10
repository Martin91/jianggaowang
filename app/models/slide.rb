class Slide < ActiveRecord::Base
  validates :title, :description, :user_id, :filename, presence: true
  has_many :previews, dependent: :destroy
  has_many :likes
  has_many :liking_users, through: :likes, source: :user
  belongs_to :category, counter_cache: true
  belongs_to :user

  after_create :auto_generate_previews

  scope :hotest, -> { where('visits_count > 0').order(visits_count: :desc).limit(12) }
  scope :newest, -> { order(created_at: :desc).limit(12) }

  def persistent_previews
    total_pages = retrieve_total_pages
    watermark_text = Qiniu::Utils.urlsafe_base64_encode("讲稿网：@#{user.name}")
    bucket = Qiniu::Bucket

    pfops = (1..retrieve_total_pages).map do |page|
      target_key = Digest::MD5.hexdigest(filename) + "-#{page}.jpg"

      "odconv/jpg/page/#{page}/density/150/resize/800|" +
      "watermark/2/text/#{watermark_text}/fontsize/500/dissolve/60|" +
      "saveas/#{Qiniu::Utils.encode_entry_uri(bucket, target_key)}"
    end.join(';')

    notify_url = "#{Qiniu::NotificationHost}/notifications/persistance_finished"
    pfop_policy = Qiniu::Fop::Persistance::PfopPolicy.new(bucket, filename, pfops, notify_url)
    pfop_policy.pipeline = Qiniu::MPSQueue

    response = Qiniu::Fop::Persistance.pfop pfop_policy
    persistent_id = response[1]["persistentId"]

    if persistent_id
      update_attributes persistent_id: persistent_id, persistent_state: "transforming"
    end
  end

  def retrieve_total_pages
    uri = URI URI.encode("http://#{Qiniu::Bucket}.qiniudn.com/#{filename}?odconv/jpg/info")
    response = JSON.parse Net::HTTP.get(uri)
    response["page_num"]
  end

  def auto_generate_previews
    delay.persistent_previews
  end

  def increase_visits_counter
    increment! :visits_count
  end
end
