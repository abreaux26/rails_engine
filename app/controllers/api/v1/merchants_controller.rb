class Api::V1::MerchantsController < ApplicationController
  # before_action :set_page, :set_per_page, only: [:index]

  def index
    @page = params.fetch(:page,1).to_i
    @per_page = params.fetch(:per_page,20).to_i

    merchants = Merchant.limit(@per_page)

    if @page > 1
      merchants = merchants.offset((@page-1) * 20)
    end

    render json: MerchantSerializer.format_merchants(merchants)
  end

  # private
  # def set_page
  #   @page = params.fetch(:page,1).to_i
  # end
  #
  # def set_per_page
  #   @per_page = params.fetch(:per_page,20).to_i
  # end
end
