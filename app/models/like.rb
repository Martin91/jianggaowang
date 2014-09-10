class Like < ActiveRecord::Base
  belongs_to :slide, counter_cache: true
  belongs_to :user
end
