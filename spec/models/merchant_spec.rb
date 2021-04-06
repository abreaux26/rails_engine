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
  end

  describe 'class methods' do
    it '::search_by_name' do
      expect(Merchant.search_by_name('ill')).to eq([@merchant_2, @merchant_1])
    end
  end
end
