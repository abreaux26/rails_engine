require 'rails_helper'
RSpec.describe Item do
  describe 'relationhips' do
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end

  before :each do
    @item_1 = create(:item, name: 'Turing', unit_price: 45.00)
    @item_2 = create(:item, name: 'Ring World', unit_price: 20.00)
    @item_3 = create(:item, name: 'World', unit_price: 50.00)

    @invoice = create(:invoice)
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice)
  end

  describe 'class methods' do
    it '::search_by_name' do
      expect(Item.search_by_name('ring')).to eq([@item_2, @item_1])
    end

    it '::search_by_max_price' do
      expect(Item.search_by_max_price(40)).to eq(@item_2)
    end

    it '::search_by_min_price' do
      expect(Item.search_by_min_price(50)).to eq(@item_3)
    end

    describe '::search_by_price' do
      it 'max and min price' do
        expect(Item.search_by_price(50, 40)).to eq(@item_1)
      end

      it 'min price ony' do
        expect(Item.search_by_price(40, nil)).to eq(@item_2)
      end

      it 'max price ony' do
        expect(Item.search_by_price(nil, 50)).to eq(@item_3)
      end
    end
  end

  describe 'instance methods' do
    describe '#destory_invoices' do
      it 'can destroy an invoice' do
        expect(@item_1.destroy_invoices).to eq([@invoice])
      end

      it 'cannot destroy an invoice' do
        @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice)

        expect(@item_2.destroy_invoices).to eq([nil])
      end
    end
  end
end
