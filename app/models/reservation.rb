class Reservation < ActiveRecord::Base

  validates :path, :uniqueness => true, :absolute_path => true
  validates :publishing_app, :presence => true

  def as_json(options = nil)
    super(options).except("id").tap do |hash|
      hash["errors"] = self.errors.as_json.stringify_keys if self.errors.any?
    end
  end

  def can_be_claimed_by?(app)
    return self.new_record? || self.publishing_app == app
  end
end
