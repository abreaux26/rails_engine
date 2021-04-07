class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    return record_bad_request if params[:quantity].to_i <= 0

    merchants = Merchant.most_items(params[:quantity])
    render json: ItemsSoldSerializer.new(merchants)
  end
end
