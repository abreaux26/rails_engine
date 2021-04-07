require 'rails_helper'
RSpec.describe Merchant do
  describe 'relationhips' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items)}
    it { should have_many(:invoices).through(:invoice_items)}
    it { should have_many(:transactions).through(:invoices)}
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  before :each do
    @merchant_1 = create(:merchant, name: 'Tillman Group')
    @merchant_2 = create(:merchant, name: 'Schiller, Barrows and Parker')

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_1)
    @item_4 = create(:item, merchant: @merchant_2)
    @item_5 = create(:item, merchant: @merchant_2)
    @item_6 = create(:item, merchant: @merchant_2)
    @item_7 = create(:item, merchant: @merchant_2)

    @invoice_1 = create(:invoice, merchant: @merchant_1)
    @invoice_2 = create(:invoice, merchant: @merchant_2)

    create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 2, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 5, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_1, item: @item_3, quantity: 13, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_2, item: @item_4, quantity: 2, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_2, item: @item_5, quantity: 6, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_2, item: @item_6, quantity: 20, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_2, item: @item_7, quantity: 1, unit_price: 1.00)

    create(:transaction, invoice: @invoice_1)
    create(:transaction, invoice: @invoice_2)
  end

  describe 'class methods' do
    it '::search_by_name' do
      expect(Merchant.search_by_name('ill')).to eq([@merchant_2, @merchant_1])
    end

    it '::most_items' do
      expect(Merchant.most_items(1)).to eq([@merchant_2])
    end

    it '::revenue' do
      expect(Merchant.revenue(2)).to eq([@merchant_2, @merchant_1])
    end
  end

  describe 'instance methods' do
    it '#revenue' do
      expect(@merchant_1.revenue).to eq(20.00)
    end
  end
end
