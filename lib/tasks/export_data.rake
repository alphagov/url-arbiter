require "tasks/export_data"

namespace :export_reservations do
  desc "Exports all content items to ./tmp as JSON, including separate timestamps"
  task all: [:environment] do
    File.open(Rails.root + "tmp/reservations_#{Time.now.strftime("%Y-%m-%d_%H-%M-%S")}.json", "w") do |file|
      Tasks::ExportData.new(file, STDOUT).export_all
    end
  end
end
