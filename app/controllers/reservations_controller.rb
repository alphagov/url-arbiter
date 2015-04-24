class ReservationsController < ApplicationController
  before_filter :parse_json_request, :only => [:update]

  def show
    @reservation = Reservation.find_by_path!(encoded_reserved_path)
    render :json => @reservation
  end

  def update
    @reservation = Reservation.find_or_initialize_by(:path => encoded_reserved_path)

    if @reservation.can_be_claimed_by?(@request_data["publishing_app"])
      status_to_use = @reservation.new_record? ? :created : :ok
      @reservation.update_attributes(@request_data) or status_to_use = :unprocessable_entity
    else
      @reservation.errors.add(:path, "is already reserved by the '#{@reservation.publishing_app}' app")
      status_to_use = :conflict
    end

    render :json => @reservation, :status => status_to_use
  end

  private

  def parse_json_request
    @request_data = JSON.parse(request.body.read)
  rescue JSON::ParserError => e
    response_body = {
      errors: {
        request_body: ["invalid JSON: #{e.message}"]
      }
    }
    render json: response_body, status: :bad_request
  end

  # Rails unescapes %encoded chars for us, so we need to re-encode them to ensure consistency.
  def encoded_reserved_path
    URI.escape(reserved_path)
  end

  def reserved_path
    params.fetch(:reserved_path)
  end
end
