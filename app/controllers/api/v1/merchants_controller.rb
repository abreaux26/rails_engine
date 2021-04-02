class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.pagination(per_page, page)
    render json: MerchantSerializer.format_merchants(merchants)
  end
end
