class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items, dependent: :destroy
  has_many :transactions
  belongs_to :customer
  belongs_to :merchant

  validates :customer_id, presence: true
  validates :merchant_id, presence: true
  validates :status, presence: true
end
