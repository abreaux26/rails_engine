require 'rails_helper'

RSpec.describe "Merchants API" do
  before :each do
    create_list(:merchant, 100)
  end

  describe 'happy path' do
    it "sends a list of merchants" do
      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(20)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq('merchant')

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'shows page 1 is the same list of first 20' do
      get '/api/v1/merchants'
      first_20 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/merchants?page=1'
      expect(response).to be_successful
      page_1 = JSON.parse(response.body, symbolize_names: true)

      expect(first_20[:data]).to eq(page_1[:data])
    end

    it 'shows second page of 20 merchants' do
      get '/api/v1/merchants?page=1'
      page_1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/merchants?page=2'

      expect(response).to be_successful

      page_2 = JSON.parse(response.body, symbolize_names: true)

      expect(page_2[:data].count).to eq(20)

      page_1_first_id = page_1[:data].first[:id].to_i
      page_2_first_id = page_1_first_id + 20

      expect(page_2[:data].first[:id].to_i).to eq(page_2_first_id)
    end

    it 'shows first page of 50 merchants' do
      get '/api/v1/merchants?per_page=50'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(50)
    end

    it 'shows a blank page of merchants which would contain no data' do
      get '/api/v1/merchants?page=200'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(0)
    end

    it 'shows all merchants if per page is really big' do
      get '/api/v1/merchants?per_page=200'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(100)
    end
  end

  describe 'sad path' do
    it 'shows page 1 if page is 0 or lower' do
      get '/api/v1/merchants?page=1'
      page_1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/merchants?page=0'
      expect(response).to be_successful
      page_0 = JSON.parse(response.body, symbolize_names: true)

      expect(page_1[:data]).to eq(page_0[:data])
    end
  end
end
