class User < ApplicationRecord
  has_many :images, dependent: :destroy

  validates :email, uniqueness: true, presence: true, email: true

  self.implicit_order_column = 'created_at'
end
