class Item < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  def self.search_by_max_price(max_price)
    where('unit_price <= ?', max_price).order(:name).first
  end

  def self.search_by_min_price(min_price)
    where('unit_price >= ?', min_price).order(:name).first
  end

  def self.search_by_price(max_price, min_price)
    if !max_price.nil? && !min_price.nil?
      where('unit_price between ? and ?', min_price, max_price).order(:name).first
    else
      return search_by_max_price(max_price) unless max_price.nil?
      return search_by_min_price(min_price) unless min_price.nil?
    end
  end

  def self.revenue(limit)
    joins(invoices: :transactions)
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .group(:id)
    .order('revenue desc')
    .limit(limit)
  end

  def destroy_invoices
    invoices.map do |invoice|
      invoice.destroy if invoice.invoice_items.all? { |ii| ii.item_id == id }
    end
  end
end
