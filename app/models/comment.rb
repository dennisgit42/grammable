class Comment < ApplicationRecord
  belongs_to :gram
  belongs_to :user
end
