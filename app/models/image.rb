class Image < ApplicationRecord
  belongs_to :user

  enum status: { uploaded: 1, compressed: 2, failed: 3 }

  self.implicit_order_column = 'created_at'
end
