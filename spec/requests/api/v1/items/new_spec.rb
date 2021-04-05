require 'rails_helper'
RSpec.describe 'New Item API' do
  before :each do
    @merchant = create(:merchant)
  end

  describe 'happy path' do
    it "can create a new item" do
      item_params = ({
                      name: "value1",
                      description: "value2",
                      unit_price: 100.99,
                      merchant_id: @merchant.id
                })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(response.status).to eq 201
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  describe 'sad path' do
    it 'missing an attribute' do
      item_params = ({
                      name: "value1",
                      description: "value2",
                      unit_price: 100.99
                })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(response.body).to eq("Merchant must exist and Merchant can't be blank")
    end

    it 'ignores any attributes sent by the user which are not allowed' do
      item_params = ({
                      name: "value1",
                      description: "value2",
                      unit_price: 100.99,
                      merchant_id: @merchant.id,
                      title: 'not supposed to be here'
                })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
      expect(item_params[:title]).to eq("not supposed to be here")
    end
  end
end
