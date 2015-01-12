class ChangeFinderApiReservationsToSpecialistPublisher < ActiveRecord::Migration
  def up
    reservations = Reservation.where(publishing_app: "finder-api")
    reservations.each do |r|
      r.update_attributes(publishing_app: "specialist-publisher")
      puts "changed publishing app for #{r.path}"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
