class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    return record_bad_request if invalid_quantity?

    merchants = Merchant.most_items(params[:quantity])
    render json: ItemsSoldSerializer.new(merchants)
  end

  private

  def invalid_quantity?
    params[:quantity].to_i <= 0
  end
end
