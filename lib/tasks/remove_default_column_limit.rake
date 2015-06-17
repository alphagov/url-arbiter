desc "Disable the default column limit applied in rails 4.1.x"
task :remove_default_column_limit do
  require File.dirname(__FILE__) + '/../../config/initializers/remove_default_column_limit'
end
