class Gram < ApplicationRecord
  validates :message, presence: true
  validates :picture, presence: true
  belongs_to :user
  mount_uploader :picture, PictureUploader 
end
