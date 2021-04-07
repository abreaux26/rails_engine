class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchants = Merchant.search_by_name(params[:name].downcase) if params[:name]
    render json: MerchantSerializer.new(merchants)
  end
end
