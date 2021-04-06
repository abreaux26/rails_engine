require 'rails_helper'
RSpec.describe 'Find one Item API' do
  before :each do
    @item_1 = create(:item, name: 'Turing', unit_price: 4.00)
    @item_2 = create(:item, name: 'Ring World', unit_price: 10.00)
    @item_3 = create(:item, name: 'World', unit_price: 60.00)
    @item_4 = create(:item, name: 'New Item', unit_price: 50.00)
    @item_5 = create(:item, name: 'Another Item', unit_price: 160.00)
  end

  describe 'happy path' do
    it 'show one item by min price' do
      get '/api/v1/items/find_one?min_price=50'

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id].to_i).to be_an(Integer)

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to eq('item')

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes][:name]).to eq(@item_5.name)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes][:description]).to eq(@item_5.description)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price].to_f).to be_a(Float)
      expect(item[:data][:attributes][:unit_price].to_f).to eq(@item_5.unit_price.to_f)

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
      expect(item[:data][:attributes][:merchant_id]).to eq(@item_5.merchant_id)
    end

    it 'min_price is so big that nothing matches' do
      get '/api/v1/items/find_one?min_price=500000000'

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to eq([])
    end

    it 'shows one item by max price' do
      get '/api/v1/items/find_one?max_price=150'

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id].to_i).to be_an(Integer)

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to eq('item')

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes][:name]).to eq(@item_4.name)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes][:description]).to eq(@item_4.description)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price].to_f).to be_a(Float)
      expect(item[:data][:attributes][:unit_price].to_f).to eq(@item_4.unit_price.to_f)

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
      expect(item[:data][:attributes][:merchant_id]).to eq(@item_4.merchant_id)
    end

    it 'max_price is so small that nothing matches' do
      get '/api/v1/items/find_one?max_price=1.99'

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to eq([])
    end

    it 'shows one item between min and max price' do
      get '/api/v1/items/find_one?max_price=65&&min_price=55'

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id].to_i).to be_an(Integer)

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to eq('item')

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes][:name]).to eq(@item_3.name)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes][:description]).to eq(@item_3.description)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price].to_f).to be_a(Float)
      expect(item[:data][:attributes][:unit_price].to_f).to eq(@item_3.unit_price.to_f)

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
      expect(item[:data][:attributes][:merchant_id]).to eq(@item_3.merchant_id)
    end
  end

  describe 'sad path' do
    it 'min_price less than 0' do
      get '/api/v1/items/find_one?min_price=-5'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end

    it 'cannot send name and min_price' do
      get '/api/v1/items/find_one?name=ring&min_price=50'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end

    it 'max_price less than 0' do
      get '/api/v1/items/find_one?max_price=-5'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end

    it 'cannot send name and max_price' do
      get '/api/v1/items/find_one?name=ring&max_price=50'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end
  end
end
