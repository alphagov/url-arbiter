class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound, :with => :error_404

  private

  def error_404
    head 404
  end
end
