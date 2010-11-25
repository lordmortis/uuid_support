module UUIDSupport
  class UUIDSupport < ::Rails::Railtie
		initializer "my_cool_railtie.boot_adapter_hooks", :after => "active_record.initialize_database" do
			ActiveSupport.on_load :active_record do
				require 'uuid_support/uuid_schema_definitions.rb'
				require 'uuid_support/uuid_fields_mysql' if (defined?(ActiveRecord::ConnectionAdapters::MysqlAdapter) != nil)
				require 'uuid_support/uuid_fields_postgresql' if (defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) != nil)				
#			  ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval { include MysqlAdapterExtensions } 
			end
		end
  end
end