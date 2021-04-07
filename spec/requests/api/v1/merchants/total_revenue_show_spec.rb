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
    it 'revenue for merchant id' do
      get "/api/v1/revenue/merchants/#{@merchant_3.id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(merchant[:data].count).to eq(1)
      merchant = merchant[:data][0]

      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to eq(@merchant_3.id)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq('merchant_revenue')

      expect(merchant[:attributes]).to have_key(:revenue)
      expect(merchant[:attributes][:revenue]).to be_a(Float)
      expect(merchant[:attributes][:revenue]).to eq(22.00)
    end
  end

  describe 'sad path' do
    it 'bad integer id returns 404' do
      get "/api/v1/revenue/merchants/8923987297"

      expect(response).to be_successful
      expect(response.status).to eq 404
    end
  end
end
