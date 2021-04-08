class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer
  belongs_to :merchant

  validates :customer_id, presence: true
  validates :merchant_id, presence: true
  validates :status, presence: true

  def self.destroy_invoices(item_id)
    unless other_items?(item_id)
      invoices_for(item_id).destroy_all
    end
  end

  def self.other_items?(item_id)
    joins(:invoice_items).where.not('invoice_items.item_id = ?', item_id).any?
  end

  def self.invoices_for(item_id)
    joins(:invoice_items).where('invoice_items.item_id = ?', item_id)
  end
end
