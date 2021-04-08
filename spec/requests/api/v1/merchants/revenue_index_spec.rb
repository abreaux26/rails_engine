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

    create(:transaction, invoice: @invoice_1, result: 'failed')
    create(:transaction, invoice: @invoice_2, result: 'failed')
    create(:transaction, invoice: @invoice_3)
    create(:transaction, invoice: @invoice_4)
  end

  describe 'happy path' do
    it 'most revenue for merchants' do
      get "/api/v1/revenue/merchants?quantity=2"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(2)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq('merchant_name_revenue')

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)

        expect(merchant[:attributes]).to have_key(:revenue)
        expect(merchant[:attributes][:revenue]).to be_a(Float)
      end
    end

    it 'top one merchant by revenue' do
      get "/api/v1/revenue/merchants?quantity=1"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(merchant[:data].count).to eq(1)
      merchant = merchant[:data][0]

      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq('merchant_name_revenue')

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to eq(@merchant_3.name)

      expect(merchant[:attributes]).to have_key(:revenue)
      expect(merchant[:attributes][:revenue]).to eq(@merchant_3.revenue)
    end

    it 'shows all 2 merchants if quantity is too big' do
      get "/api/v1/revenue/merchants?quantity=10000"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(2)
    end
  end

  describe 'sad path' do
    it 'returns 400 if quantity value is blank' do
      get '/api/v1/revenue/merchants?quantity='

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end

    it 'returns 400 if quantity is a string' do
      get '/api/v1/revenue/merchants?quantity=asdasd'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end

    it 'quantity param is missing' do
      get '/api/v1/revenue/merchants'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end
  end
end
