class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound, with: ->{ show_errors(404) }

  def show_errors(status_code = params[:status_code] || 500)
    head status_code
  end
end
