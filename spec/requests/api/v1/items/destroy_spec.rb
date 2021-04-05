require 'rails_helper'
RSpec.describe 'Destroy Item API' do
  before :each do
    @item = create(:item)
  end

  describe 'happy path' do
    it "can destroy an book" do
      expect{ delete "/api/v1/items/#{@item.id}" }.to change(Item, :count).by(-1)

      expect(response).to be_successful
      expect{Item.find(@item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'sad path' do
  end
end
