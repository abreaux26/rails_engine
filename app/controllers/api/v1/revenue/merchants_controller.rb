class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    return record_bad_request if invalid_quantity?

    merchants = Merchant.revenue(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end
end
