require 'rails_helper'
RSpec.describe Merchant do
  describe 'relationhips' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items)}
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  before :each do
    @merchant_1 = create(:merchant, name: 'Tillman Group')
    @merchant_2 = create(:merchant, name: 'Schiller, Barrows and Parker')

    create_list(:item, 3, merchant: @merchant_1)
    create_list(:item, 4, merchant: @merchant_2)
  end

  describe 'class methods' do
    it '::search_by_name' do
      expect(Merchant.search_by_name('ill')).to eq([@merchant_2, @merchant_1])
    end

    it '::most_items' do
      expect(Merchant.most_items(1)).to eq([@merchant_2])
    end
  end
end
