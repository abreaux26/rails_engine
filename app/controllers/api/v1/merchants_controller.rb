class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.pagination(per_page, page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  def find_all
    merchants = Merchant.search_by_name(params[:name].downcase) if params[:name]
    render json: MerchantSerializer.new(merchants)
  end
end
