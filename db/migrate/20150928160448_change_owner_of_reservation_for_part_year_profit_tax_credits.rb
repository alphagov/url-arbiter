class ChangeOwnerOfReservationForPartYearProfitTaxCredits < ActiveRecord::Migration
  def up
    path = '/part-year-profit-tax-credits'
    reservation = Reservation.where(path: path).first
    unless reservation
      puts "WARNING: #{path} reservation not found, skipping..."
      return
    end
    reservation.update_attributes!(publishing_app: 'smartanswers')
  end

  def down
  end
end
