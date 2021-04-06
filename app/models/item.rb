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
    where('unit_price between ? and ?', min_price, max_price).order(:name).first
  end

  def destroy_invoices
    invoices.map do |invoice|
      invoice.destroy if invoice.invoice_items.all? { |ii| ii.item_id == id }
    end
  end
end
