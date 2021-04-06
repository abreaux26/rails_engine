class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.pagination(per_page, page)
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy
    item = Item.find(params[:id])
    invoices = item.invoices
    invoices.each do |invoice|
      invoice.destroy if invoice.invoice_items.all? { |ii| ii.item_id == item.id }
    end
    item.destroy
  end

  def search
    items = Item.order_by_name
    if params[:name]
      item = items.find { |p| p[:name].downcase.include? params[:name] }
    end
    render json: ItemSerializer.new(item)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
