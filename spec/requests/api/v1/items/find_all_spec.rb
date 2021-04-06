require 'rails_helper'
RSpec.describe 'Find all Items API' do
  before :each do
    @item_1 = create(:item, name: 'This is an item')
    @item_2 = create(:item, name: 'Turing')
    @item_3 = create(:item, name: 'Ring World')
    @item_4 = create(:item, name: 'Jewlrey')
    @item_5 = create(:item, name: 'Pots and pans')
  end

  describe 'happy path' do
    it 'show all items by fragment' do
      get '/api/v1/items/find_all?name=ring'

      expect(response).to be_successful

      ring_items = JSON.parse(response.body, symbolize_names: true)

      expect(ring_items[:data].count).to eq(2)

      ring_items[:data].each do |ring_item|
        expect(ring_item).to have_key(:id)
        expect(ring_item[:id].to_i).to be_an(Integer)

        expect(ring_item).to have_key(:type)
        expect(ring_item[:type]).to eq('item')

        expect(ring_item[:attributes]).to have_key(:name)
        expect(ring_item[:attributes][:name]).to be_a(String)

        expect(ring_item[:attributes]).to have_key(:description)
        expect(ring_item[:attributes][:description]).to be_a(String)

        expect(ring_item[:attributes]).to have_key(:unit_price)
        expect(ring_item[:attributes][:unit_price].to_f).to be_a(Float)

        expect(ring_item[:attributes]).to have_key(:merchant_id)
        expect(ring_item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end

  describe 'sad path' do
    it 'no fragment matched' do
      get '/api/v1/items/find_all?name=NOMATCH'

      expect(response).to be_successful

      ring_items = JSON.parse(response.body, symbolize_names: true)

      expect(ring_items[:data]).to be_an(Array)
    end
  end
end
