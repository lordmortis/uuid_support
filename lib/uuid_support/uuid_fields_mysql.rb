module ActiveRecord::ConnectionAdapters
	class MysqlAdapter
	  def native_database_types
			NATIVE_DATABASE_TYPES.merge({:uuid => { :name => "binary", :limit => 16}, :uuid_pkey => { :name => "binary(16) PRIMARY KEY"}})
	  end


		# Maps logical Rails types to MySQL-specific data types.
	  def type_to_sql(type, limit = nil, precision = nil, scale = nil)
	    return super unless type.to_s == 'integer'
			print("MYSQL: Type is: #{type}\n")
		
	    case limit
	    when 1; 'tinyint'
	    when 2; 'smallint'
	    when 3; 'mediumint'
	    when nil, 4, 11; 'int(11)'  # compatibility with MySQL default
	    when 5..8; 'bigint'
	    else raise(ActiveRecordError, "No integer type has byte size #{limit}")
	    end
	  end

		def quote(value, column = nil)
			print("Quote! #{value}\n")
      if value.kind_of?(String) && column && column.type == :binary && column.class.respond_to?(:string_to_binary)
        s = column.class.string_to_binary(value).unpack("H*")[0]
        "x'#{s}'"
      elsif value.kind_of?(BigDecimal)
        value.to_s("F")
      elsif value.kind_of?(UUIDTools::UUID)
				"0x#{value.hexdigest()}"
			else
        super
      end
    end
	end
	
	class MysqlColumn
		class << self
			def string_to_uuid(value)
				if (value.class == String)
					UUIDTools::UUID.parse_raw(value)
				else
					value
				end					
			end
		end
				
		def simplified_type(field_type)
			return :uuid if field_type.downcase.index("binary(16)")
		  return :boolean if MysqlAdapter.emulate_booleans && field_type.downcase.index("tinyint(1)")
		  return :string  if field_type =~ /enum/i
		  super
		end	
	end
	
end