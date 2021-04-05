require 'rails_helper'
RSpec.describe '' do
  before :each do
    @item = create(:item)
  end

  describe 'happy path' do
    it "can update an existing item" do
      previous_name = Item.last.name
      item_params = { name: "New Item" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{@item.id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: @item.id)

      expect(response).to be_successful
      expect(item.name).not_to eq(previous_name)
      expect(item.name).to eq("New Item")
    end
  end

  describe 'sad path' do
    it 'bad integer id returns 404' do
      item_params = { name: "New Item" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/12435678912354", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: 12435678912354)

      expect(response.status).to eq 404
    end

    it 'bad merchant id returns 404' do
      previous_name = Item.last.name
      item_params = { merchant_id: 999999999999 }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{@item.id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: @item.id)

      expect(response.status).to eq(404)
    end
  end
end
