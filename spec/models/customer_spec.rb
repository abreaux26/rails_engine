require 'rails_helper'
RSpec.describe Customer do
  describe 'relationhips' do
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices)}
  end

  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end
end
