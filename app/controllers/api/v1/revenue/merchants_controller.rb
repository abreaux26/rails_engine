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

  private

  def invalid_quantity?
    params[:quantity].to_i <= 0
  end
end
