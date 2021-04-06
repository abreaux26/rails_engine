class Api::V1::SearchController < ApplicationController
  before_action :validate_params

  def find_all
    merchants = Merchant.search_by_name(params[:name].downcase) if params[:name]
    render json: MerchantSerializer.new(merchants)
  end

  def find_one
    if params[:name]
      item = Item.search_by_name(params[:name].downcase).first
    elsif params[:max_price] && params[:min_price]
      item = Item.search_by_price(params[:max_price], params[:min_price])
    elsif params[:max_price]
      item = Item.search_by_max_price(params[:max_price])
    elsif params[:min_price]
      item = Item.search_by_min_price(params[:min_price])
    end

    if item.nil?
      render json: ItemSerializer.new([])
    else
      render json: ItemSerializer.new(item)
    end
  end

  private

  def validate_params
    if params[:name] && (params[:max_price] || params[:min_price])
      record_bad_request
    elsif params[:max_price].to_i < 0 || params[:min_price].to_i < 0
      record_bad_request
    end
  end
end
