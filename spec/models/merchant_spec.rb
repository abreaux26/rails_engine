require 'rails_helper'
RSpec.describe Merchant do
  describe 'relationhips' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items)}
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end
end
