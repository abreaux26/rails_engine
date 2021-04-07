class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates :name, presence: true

  def self.most_items(limit)
    joins(items: { invoice_items: { invoice: :transactions } })
      .select('merchants.*, sum(invoice_items.quantity) as count')
      .where('transactions.result = ?', 'success')
      .group('merchants.id')
      .order('count desc')
      .limit(limit)
  end
end
