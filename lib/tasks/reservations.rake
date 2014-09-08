namespace :reservations do

  desc "Seed reservations with data from Panopticon"
  task :seed_from_panopticon => :environment do
    require "panopticon_importer"
    PanopticonImporter.new(PANOPTICON_BEARER_TOKEN).import
  end
end
