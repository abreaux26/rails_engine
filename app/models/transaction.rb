class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :customers, through: :invoice

  validates :invoice_id, presence: true
  validates :credit_card_number, presence: true
  validates :credit_card_expiration_date, presence: true

  enum result: { failed: 0, success: 1 }
end
