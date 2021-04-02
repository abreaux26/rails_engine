class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.first(20)
    render json: MerchantSerializer.format_merchants(merchants)
  end
end
