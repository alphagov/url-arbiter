class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :path, :null => false
      t.string :publishing_app, :null => false

      t.timestamps
    end

    add_index :reservations, :path, :unique => true
  end
end
