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
    @item_1 = create(:item, name: 'Turing')
    @item_2 = create(:item, name: 'Ring World')
  end

  describe 'class methods' do
    it '::search_by_name' do
      expect(Item.search_by_name('ring')).to eq(@item_2)
    end
  end
end
