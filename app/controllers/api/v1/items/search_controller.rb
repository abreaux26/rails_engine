class Api::V1::Items::SearchController < ApplicationController
  def index
    return record_bad_request if invalid_params?
    item = if params[:name]
             Item.search_by_name(params[:name].downcase).first
           else
             Item.search_by_price(params[:max_price], params[:min_price])
           end

    render json: item.nil? ? NilSerializer.empty : ItemSerializer.new(item)
  end

  private

  def invalid_params?
    name_and_price? || negative_price?
  end

  def name_and_price?
    params[:name] && (params[:max_price] || params[:min_price])
  end

  def negative_price?
    params[:max_price].to_i.negative? || params[:min_price].to_i.negative?
  end
end
