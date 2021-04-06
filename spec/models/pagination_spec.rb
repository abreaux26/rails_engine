require 'rails_helper'
RSpec.describe ApplicationRecord do
  before :each do
    create_list(:item, 3)
  end

  describe 'class methods' do
    it '::pagination' do
      items = Item.pagination(2, 1)
      expect(items.size).to eq(2)
    end
  end
end
