require 'rails_helper'
RSpec.describe Invoice do
  describe 'relationhips' do
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
    it { should belong_to :customer }
  end

  describe 'validations' do
    it { should validate_presence_of :customer_id }
    it { should validate_presence_of :merchant_id }
    it { should define_enum_for(:status).with(packaged: 0, shipped: 1, returned: 2) }
  end
end
