require 'rails_helper'
RSpec.describe 'Merchants who sold most items API' do
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

    create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 2)
    create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 6)
    create(:invoice_item, invoice: @invoice_2, item: @item_3, quantity: 7)
    create(:invoice_item, invoice: @invoice_2, item: @item_4, quantity: 20)
    create(:invoice_item, invoice: @invoice_2, item: @item_5, quantity: 55)
    create(:invoice_item, invoice: @invoice_2, item: @item_6, quantity: 3)
    create(:invoice_item, invoice: @invoice_3, item: @item_7, quantity: 17)
    create(:invoice_item, invoice: @invoice_3, item: @item_8, quantity: 1)
    create(:invoice_item, invoice: @invoice_3, item: @item_9, quantity: 4)
    create(:invoice_item, invoice: @invoice_4, item: @item_10, quantity: 9)

    create(:transaction, invoice: @invoice_1, result: 'failed')
    create(:transaction, invoice: @invoice_2, result: 'failed')
    create(:transaction, invoice: @invoice_3)
    create(:transaction, invoice: @invoice_4)
  end

  describe 'happy path' do
    it 'shows 2 merchants with most items sold' do
      get '/api/v1/merchants/most_items?quantity=2'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(2)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq('items_sold')

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)

        expect(merchant[:attributes]).to have_key(:count)
        expect(merchant[:attributes][:count]).to be_a(Integer)
      end
    end

    it 'shows top merchant with most items sold' do
      get '/api/v1/merchants/most_items?quantity=1'

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(merchant[:data].count).to eq(1)
      merchant = merchant[:data][0]

      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to eq(@merchant_3.id)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq('items_sold')

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to eq(@merchant_3.name)

      expect(merchant[:attributes]).to have_key(:count)
      expect(merchant[:attributes][:count]).to eq(22)
    end

    it 'shows all 2 merchants if quantity is too big' do
      get '/api/v1/merchants/most_items?quantity=1000'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(2)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq('items_sold')

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)

        expect(merchant[:attributes]).to have_key(:count)
        expect(merchant[:attributes][:count]).to be_a(Integer)
      end
    end
  end

  describe 'sad path' do
    it 'returns an error of some sort if quantity value is blank' do
      get '/api/v1/merchants/most_items?quantity='

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end

    it 'returns an error of some sort if quantity is a string' do
      get '/api/v1/merchants/most_items?quantity=asdasd'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end

    it 'quantity param is missing' do
      get '/api/v1/merchants/most_items'

      expect(response).not_to be_successful
      expect(response.status).to eq 400
    end
  end
end
