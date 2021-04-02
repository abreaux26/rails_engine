class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer

  validates :customer_id, presence: true
  validates :merchant_id, presence: true

  enum status: { packaged: 0, shipped: 1, returned: 2 }
end
