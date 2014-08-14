class RemovePathLimit < ActiveRecord::Migration
  def up
    # This doesn't change anything at Rails' level, but it causes the change in
    # config/initializers/remove_default_column_limit.rb to take effect.
    change_column :reservations, :path, :string
    change_column :reservations, :publishing_app, :string
  end

  def down
  end
end
