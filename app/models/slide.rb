class Slide < ActiveRecord::Base
  validates :title, :description, :user_id, :filename, presence: true
  belongs_to :category
end
