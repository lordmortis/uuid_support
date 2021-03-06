module UUIDSupport
  class UUIDSupport < ::Rails::Railtie
		initializer "uuid_support.boot_adapter_hooks", :after => "active_record.initialize_database" do
			ActiveSupport.on_load :active_record do
				require 'uuid_support/uuid_schema_definitions.rb'
				require 'uuid_support/uuid_activerecord_persistence'
				require 'uuid_support/uuid_fields_sqlite' if (defined?(ActiveRecord::ConnectionAdapters::SQLiteAdapter) != nil)
				require 'uuid_support/uuid_fields_mysql' if (defined?(ActiveRecord::ConnectionAdapters::MysqlAdapter) != nil)
				require 'uuid_support/uuid_fields_postgresql' if (defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) != nil)		
				require 'uuid_support/uuid_fields_arel' if (defined?(Arel::Visitors) != nil)
			end
		end
  end
end