class Order < ApplicationRecord
  belongs_to :customer

  validates :customer_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :product_name, presence: true
  validates :product_count, presence: true, numericality: { only_integer: true, in: (1..100000) }
end
