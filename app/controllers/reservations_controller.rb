class ReservationsController < ApplicationController
  before_filter :parse_json_request, :only => [:update]

  def update
    @reservation = Reservation.find_or_initialize_by(:path => params[:reserved_path])

    if @reservation.can_be_claimed_by?(@request_data["publishing_app"])
      status_to_use = @reservation.new_record? ? :created : :ok
      @reservation.update_attributes(@request_data) or status_to_use = :unprocessable_entity
    else
      @reservation.errors.add(:base, "is already reserved by the '#{@reservation.publishing_app}' app")
      status_to_use = :conflict
    end

    render :json => @reservation, :status => status_to_use
  end

  private

  def parse_json_request
    @request_data = JSON.parse(request.body.read)
  rescue JSON::ParserError
    head :bad_request
  end
end
