class Api::V1::SearchController < ApplicationController
  before_action :validate_params

  def find_all
    merchants = Merchant.search_by_name(params[:name].downcase) if params[:name]
    render json: MerchantSerializer.new(merchants)
  end

  def find_one
    item = if params[:name]
             Item.search_by_name(params[:name].downcase).first
           else
             Item.search_by_price(params[:max_price], params[:min_price])
           end

    render json: item.nil? ? NilSerializer.empty : ItemSerializer.new(item)
  end

  private

  def validate_params
    if params[:name] && (params[:max_price] || params[:min_price])
      record_bad_request
    elsif params[:max_price].to_i.negative? || params[:min_price].to_i.negative?
      record_bad_request
    end
  end
end
