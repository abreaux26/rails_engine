require 'rails_helper'
RSpec.describe 'Total revenue for a given merchant API' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)
    @merchant_4 = create(:merchant)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_2)
    @item_4 = create(:item, merchant: @merchant_2)
    @item_5 = create(:item, merchant: @merchant_2)
    @item_6 = create(:item, merchant: @merchant_2)
    @item_7 = create(:item, merchant: @merchant_3)
    @item_8 = create(:item, merchant: @merchant_3)
    @item_9 = create(:item, merchant: @merchant_3)
    @item_10 = create(:item, merchant: @merchant_4)

    @invoice_1 = create(:invoice, merchant: @merchant_1)
    @invoice_2 = create(:invoice, merchant: @merchant_2)
    @invoice_3 = create(:invoice, merchant: @merchant_3)
    @invoice_4 = create(:invoice, merchant: @merchant_4)
    @invoice_5 = create(:invoice, merchant: @merchant_4)
    @invoice_6 = create(:invoice, merchant: @merchant_4)
    @invoice_7 = create(:invoice, merchant: @merchant_4)
    @invoice_8 = create(:invoice, merchant: @merchant_4)
    @invoice_9 = create(:invoice, merchant: @merchant_4)
    @invoice_10 = create(:invoice, merchant: @merchant_4)

    create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 2, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 6, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_2, item: @item_3, quantity: 7, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_2, item: @item_4, quantity: 20, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_2, item: @item_5, quantity: 55, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_2, item: @item_6, quantity: 3, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_3, item: @item_7, quantity: 17, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_3, item: @item_8, quantity: 1, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_3, item: @item_9, quantity: 4, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_4, item: @item_10, quantity: 9, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_5, item: @item_10, quantity: 5, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_6, item: @item_10, quantity: 19, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_7, item: @item_10, quantity: 6, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_8, item: @item_10, quantity: 25, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_9, item: @item_10, quantity: 4, unit_price: 1.00)
    create(:invoice_item, invoice: @invoice_10, item: @item_10, quantity: 3, unit_price: 1.00)

    create(:transaction, invoice: @invoice_1, result: 'failed')
    create(:transaction, invoice: @invoice_2, result: 'failed')
    create(:transaction, invoice: @invoice_3)
    create(:transaction, invoice: @invoice_4)
    create(:transaction, invoice: @invoice_5)
    create(:transaction, invoice: @invoice_6)
    create(:transaction, invoice: @invoice_7)
    create(:transaction, invoice: @invoice_8)
    create(:transaction, invoice: @invoice_9)
    create(:transaction, invoice: @invoice_10)
  end

  describe 'happy path' do
    it 'top items by revenue default params' do
      get "/api/v1/revenue/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(4)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item_revenue')

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price].to_f).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)

        expect(item[:attributes]).to have_key(:revenue)
        expect(item[:attributes][:revenue].to_f).to be_a(Float)
      end
    end

    it 'top one item by revenue' do
      get "/api/v1/revenue/items?quantity=1"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)
      expect(item[:data].count).to eq(1)
      item = item[:data][0]

      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be_an(Integer)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item_revenue')

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to eq(@item_10.name)

      expect(item[:attributes]).to have_key(:revenue)
      expect(item[:attributes][:revenue].to_f).to eq(71.00)
    end

    it 'shows all items if quantity is too big' do
      get "/api/v1/revenue/items?quantity=10000"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(4)
    end
  end

  describe 'sad path' do
    it 'returns 400 if quantity value is less than 0' do
      get '/api/v1/revenue/items?quantity=-5'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end

    it 'returns 400 if quantity value is blank' do
      get '/api/v1/revenue/items?quantity='

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end

    it 'returns 400 if quantity is a string' do
      get '/api/v1/revenue/items?quantity=asdasd'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end
  end
end
