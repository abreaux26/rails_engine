require 'rails_helper'
RSpec.describe 'Find all Merchants API' do
  before :each do
    @merchant_1 = create(:merchant, name: 'Schiller, Barrows and Parker')
    @merchant_2 = create(:merchant, name: 'Tillman Group')
    @merchant_3 = create(:merchant, name: 'Williamson Group')
    @merchant_4 = create(:merchant, name: 'Williamson Group')
    @merchant_5 = create(:merchant, name: 'Willms and Sons')
  end

  describe 'happy path' do
    it 'show all merchants by fragment' do
      get '/api/v1/merchants/find_all?name=ILL'

      expect(response).to be_successful

      ill_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(ill_merchants[:data].count).to eq(5)

      ill_merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq('merchant')

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe 'sad path' do
    it 'no fragment matched' do
      get '/api/v1/merchants/find_all?name=NOMATCH'

      expect(response).to be_successful

      ill_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(ill_merchants[:data]).to be_an(Array)
    end
  end
end
