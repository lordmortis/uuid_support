class ActiveRecord::ConnectionAdapters::MysqlAdapter
  def native_database_types
		print("Moo\n")
		temp = NATIVE_DATABASE_TYPES.merge({:uuid => { :name => "binary", :limit => 32}, :uuid_pkey => { :name => "binary(32) PRIMARY KEY"}})
		for key, val in temp
			print("\tType: #{key}\n")
		end
		
		temp
  end
end