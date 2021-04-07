class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    merchants = Merchant.most_items(params[:quantity]) if params[:quantity]
    render json: ItemsSoldSerializer.new(merchants)
  end
end
