class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true, email: true

  self.implicit_order_column = 'created_at'
end
