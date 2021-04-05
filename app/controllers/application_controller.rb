class ApplicationController < ActionController::API
  include ActionController::Helpers
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_not_found
  helper_method :page, :per_page


  def page
    params.fetch(:page, 1).to_i
  end

  def per_page
    params.fetch(:per_page, 20).to_i
  end

  private

  def record_not_found
    render plain: "404 Not Found", status: 404
  end
end
