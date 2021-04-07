class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items

  validates :name, presence: true

  def self.most_items(limit)
    joins(:items)
    .group('merchants.id')
    .order(Arel.sql('count(items) desc'))
    .limit(limit)
  end
end
