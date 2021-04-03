require 'rails_helper'

RSpec.describe "Merchants API" do
  before :each do
    @merchant = create(:merchant)
  end

  describe 'happy path' do
    it 'can get one merchant by its id' do
      get "/api/v1/merchants/#{@merchant.id}"
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id].to_i).to eq(@merchant.id)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe 'sad path' do
    it 'returns 404 with bad id' do
      get "/api/v1/merchants/8923987297"

      expect(response.status).to eq 404
    end
  end
end
