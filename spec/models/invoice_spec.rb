require 'rails_helper'
RSpec.describe Invoice do
  describe 'relationhips' do
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
    it { should belong_to :customer }
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :customer_id }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :status }
  end

  before :each do
    @item_1 = create(:item, name: 'Turing', unit_price: 45.00)
    @item_2 = create(:item, name: 'Ring World', unit_price: 20.00)
    @item_3 = create(:item, name: 'World', unit_price: 50.00)

    @invoice = create(:invoice)
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice, quantity: 2, unit_price: 5.00)
  end

  describe 'class methods' do
    describe '::destroy_invoices' do
      it 'has invoices to destory' do

        expect(Invoice.destroy_invoices(@item_1.id)).to eq([@invoice])
      end

      it 'does not have invoices to destory' do
        @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice)

        expect(Invoice.destroy_invoices(@item_2.id)).to eq(nil)
      end
    end

    describe '::other_items?' do
      it 'has other items' do
        @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice)

        expect(Invoice.other_items?(@item_1.id)).to be_truthy
      end

      it 'does not have other items' do
        expect(Invoice.other_items?(@item_1.id)).to be_falsy
      end
    end
    
    it '::invoices_for' do
      expect(Invoice.invoices_for(@item_1.id)).to eq([@invoice])
    end
  end
end
