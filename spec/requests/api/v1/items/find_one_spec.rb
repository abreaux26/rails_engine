require 'rails_helper'
RSpec.describe 'Find one Item API' do
  before :each do
    @item_1 = create(:item, name: 'This is an item')
    @item_2 = create(:item, name: 'Turing')
    @item_3 = create(:item, name: 'Ring World')
    @item_4 = create(:item, name: 'Jewlrey')
    @item_5 = create(:item, name: 'Pots and pans')
  end

  describe 'happy path' do
    it 'show one item by fragment' do
      get '/api/v1/items/find_one?name=ring'

      expect(response).to be_successful

      ring_item = JSON.parse(response.body, symbolize_names: true)

      expect(ring_item[:data]).to have_key(:id)
      expect(ring_item[:data][:id].to_i).to be_an(Integer)

      expect(ring_item[:data]).to have_key(:type)
      expect(ring_item[:data][:type]).to eq('item')

      expect(ring_item[:data][:attributes]).to have_key(:name)
      expect(ring_item[:data][:attributes][:name]).to be_a(String)
      expect(ring_item[:data][:attributes][:name]).to eq(@item_3.name)

      expect(ring_item[:data][:attributes]).to have_key(:description)
      expect(ring_item[:data][:attributes][:description]).to be_a(String)
      expect(ring_item[:data][:attributes][:description]).to eq(@item_3.description)

      expect(ring_item[:data][:attributes]).to have_key(:unit_price)
      expect(ring_item[:data][:attributes][:unit_price].to_f).to be_a(Float)
      expect(ring_item[:data][:attributes][:unit_price].to_f).to eq(@item_3.unit_price)

      expect(ring_item[:data][:attributes]).to have_key(:merchant_id)
      expect(ring_item[:data][:attributes][:merchant_id]).to be_a(Integer)
      expect(ring_item[:data][:attributes][:merchant_id]).to eq(@item_3.merchant_id)
    end
  end

  describe 'sad path' do
    it 'no fragment matched' do
      get '/api/v1/items/find_one?name=NOMATCH'

      expect(response).to be_successful

      ring_item = JSON.parse(response.body, symbolize_names: true)

      expect(ring_item[:data]).to be_nil
    end
  end
end
