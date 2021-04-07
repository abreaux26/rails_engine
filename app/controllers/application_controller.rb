class ApplicationController < ActionController::API
  include ActionController::Helpers
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_not_found
  helper_method :page, :per_page, :invalid_params?

  def page
    params.fetch(:page, 1).to_i
  end

  def per_page
    params.fetch(:per_page, 20).to_i
  end

  def invalid_params?
    name_and_price? || negative_price?
  end

  def name_and_price?
    params[:name] && (params[:max_price] || params[:min_price])
  end

  def negative_price?
    params[:max_price].to_i.negative? || params[:min_price].to_i.negative?
  end

  def invalid_quantity?
    params[:quantity].to_i <= 0
  end

  private

  def record_not_found
    render plain: '404 Not Found', status: :not_found
  end

  def record_bad_request
    render json: { error: '400 Bad Request' }, status: :bad_request
  end
end
