require 'rails_helper'
RSpec.describe 'Items API' do
  before :each do
    create_list(:item, 100)
  end

  describe 'happy path' do
    it "sends a list of items" do
      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price].to_f).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    it 'shows page 1 is the same list of first 20' do
      get '/api/v1/items'
      first_20 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/items?page=1'
      expect(response).to be_successful
      page_1 = JSON.parse(response.body, symbolize_names: true)

      expect(first_20[:data]).to eq(page_1[:data])
    end

    it 'shows second page of 20 items' do
      get '/api/v1/items?page=1'
      page_1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/items?page=2'

      expect(response).to be_successful

      page_2 = JSON.parse(response.body, symbolize_names: true)

      expect(page_2[:data].count).to eq(20)

      page_1_first_id = page_1[:data].first[:id].to_i
      page_2_first_id = page_1_first_id + 20

      expect(page_2[:data].first[:id].to_i).to eq(page_2_first_id)
    end

    it 'shows first page of 50 items' do
      get '/api/v1/items?per_page=50'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(50)
    end

    it 'shows a blank page of items which would contain no data' do
      get '/api/v1/items?page=20000'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(0)
    end

    it 'shows all items if per page is really big' do
      get '/api/v1/items?per_page=250000'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(100)
    end
  end

  describe 'sad path' do
    it 'shows page 1 if page is 0 or lower' do
      get '/api/v1/items?page=1'
      page_1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/items?page=0'
      expect(response).to be_successful
      page_0 = JSON.parse(response.body, symbolize_names: true)

      expect(page_1[:data]).to eq(page_0[:data])
    end
  end
end
