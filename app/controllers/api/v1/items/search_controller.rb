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
end
