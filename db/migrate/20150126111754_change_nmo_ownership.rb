class ChangeNmoOwnership < ActiveRecord::Migration
  def up
    reservation = Reservation.where(path: '/national-measurement-office').first
    unless reservation
      puts "WARNING: /national-measurement-office reservation not found, skipping..."
      return
    end
    reservation.update_attributes!(publishing_app: 'short-url-manager')
  end

  def down
  end
end
