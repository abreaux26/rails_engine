class ApplicationController < ActionController::API
  include ActionController::Helpers

  def page
    params.fetch(:page, 1).to_i
  end

  def per_page
    params.fetch(:per_page, 20).to_i
  end

  helper_method :page, :per_page
end
