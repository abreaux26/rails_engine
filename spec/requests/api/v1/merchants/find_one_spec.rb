require 'rails_helper'
RSpec.describe 'Find one Item API' do
  before :each do
    @merchant_1 = create(:merchant, name: 'Williamson Group')
    @merchant_2 = create(:merchant, name: 'Tillman Group')
    @merchant_3 = create(:merchant, name: 'Schiller, Barrows and Parker')
    @merchant_4 = create(:merchant, name: 'Williamson Group')
    @merchant_5 = create(:merchant, name: 'Willms and Sons')
  end

  describe 'happy path' do
    it 'show one merchant by fragment' do
      get '/api/v1/merchants/find_one?name=ILL'

      expect(response).to be_successful

      ill_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(ill_merchant[:data]).to have_key(:id)
      expect(ill_merchant[:data][:id].to_i).to be_an(Integer)

      expect(ill_merchant[:data]).to have_key(:type)
      expect(ill_merchant[:data][:type]).to eq('merchant')

      expect(ill_merchant[:data][:attributes]).to have_key(:name)
      expect(ill_merchant[:data][:attributes][:name]).to be_a(String)
      expect(ill_merchant[:data][:attributes][:name]).to eq(@merchant_3.name)
    end
  end

  describe 'sad path' do
    it 'no fragment matched' do
      get '/api/v1/merchants/find_one?name=NOMATCH'

      expect(response).to be_successful

      ill_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(ill_merchant[:data]).to be_nil
    end
  end
end
