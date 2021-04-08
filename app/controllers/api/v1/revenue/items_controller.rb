class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    return record_bad_request if invalid_quantity?

    items = Item.revenue(quantity)
    render json: ItemRevenueSerializer.new(items)
  end

  private

  def quantity
    params.fetch(:quantity, 10).to_i
  end

  def invalid_quantity?
    params[:quantity].to_i <= 0 unless params[:quantity].nil?
  end
end
