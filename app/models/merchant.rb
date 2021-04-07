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
      .group(:id)
      .order('count desc')
      .limit(limit)
  end

  def revenue
    transactions
      .where('transactions.result = ?', 'success')
      .where('invoices.status = ?', 'shipped')
      .pluck(Arel.sql('sum(invoice_items.unit_price * invoice_items.quantity)'))
      .first
      .to_f
  end

  def self.revenue(limit)
    joins(:transactions)
      .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
      .where('transactions.result = ?', 'success')
      .where('invoices.status = ?', 'shipped')
      .group(:id)
      .order('revenue desc')
      .limit(limit)
  end
end
