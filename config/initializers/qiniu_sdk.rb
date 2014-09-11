# rescue is used to compatiable with coding.net
access_key = Rails.application.secrets[:qiniu]['access_key'] rescue ENV["qiniu_access_key"]
secret_key = Rails.application.secrets[:qiniu]['secret_key'] rescue ENV["qiniu_secret_key"]
Qiniu.establish_connection! :access_key => access_key,
                            :secret_key => secret_key
Qiniu::Bucket = Rails.application.secrets[:qiniu]['bucket'] rescue ENV["qiniu_bucket"]
Qiniu::MPSQueue = Rails.application.secrets[:qiniu]['mps_queue'] rescue ENV["qiniu_mps_queue"]
Qiniu::NotificationHost = Rails.application.secrets[:host] rescue ENV["notification_host"]
