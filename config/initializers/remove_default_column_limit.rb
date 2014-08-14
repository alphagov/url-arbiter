require 'active_record/connection_adapters/postgresql_adapter'

# The Postgresql adapter has a default limit on string columns of 255 chars.  This causes
# the column to be defined as 'character varying(255)' in the database.  It's also not possible
# to override this default by setting limit to nil because the default is applied whenever the
# given option is falsey[1]. This default has been removed in master[2] and will likely be included
# in Rails 4.2. This override should therefore be removed when Rails is upgraded beyond that.
#
# [1] https://github.com/rails/rails/blob/v4.1.4/activerecord/lib/active_record/connection_adapters/abstract/schema_statements.rb#L702
# [2] https://github.com/rails/rails/pull/14579
#
if ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:string][:limit] == 255
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:string].delete(:limit)
else
  raise "Default string limit for postgres is not set to 255.  Review monkey-patch in #{__FILE__}."
end
