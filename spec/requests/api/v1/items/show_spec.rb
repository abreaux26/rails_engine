require 'rails_helper'

RSpec.describe "Items API" do
  before :each do
    @item = create(:item)
  end

  describe 'happy path' do
    it 'can get one item by its id' do
      get "/api/v1/items/#{@item.id}"
      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id].to_i).to eq(@item.id)

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to eq('item')

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price].to_f).to be_a(Float)

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)

    end
  end

  describe 'sad path' do
    it 'returns 404 with bad id' do
      get "/api/v1/items/8923987297"

      expect(response.status).to eq 404
    end

    it 'returns 404 with string id' do
      get "/api/v1/items/string-instead-of-integer"

      expect(response.status).to eq 404
    end
  end
end
