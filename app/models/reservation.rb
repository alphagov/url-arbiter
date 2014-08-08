class Reservation < ActiveRecord::Base

  validates :path, :uniqueness => true, :absolute_path => true
  validates :publishing_app, :presence => true
end
