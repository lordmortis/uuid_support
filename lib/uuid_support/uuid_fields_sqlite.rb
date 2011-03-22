module ActiveRecord::ConnectionAdapters
	class SQLiteColumn
		class <<  self
			def string_to_uuid(value)
				if (value.class == String)
					UUIDTools::UUID.parse_raw(binary_to_string(value))
				else
					value
				end					
			end
		end
		
		def simplified_type(field_type)
			return :uuid if field_type.downcase.index("binary(16)")
		  super
    end
		
	end
	
	class SQLiteAdapter
	  def native_database_types
      {
        :primary_key => default_primary_key_type,
        :string      => { :name => "varchar", :limit => 255 },
        :text        => { :name => "text" },
        :integer     => { :name => "integer" },
        :float       => { :name => "float" },
        :decimal     => { :name => "decimal" },
        :datetime    => { :name => "datetime" },
        :timestamp   => { :name => "datetime" },
        :time        => { :name => "time" },
        :date        => { :name => "date" },
        :binary      => { :name => "blob" },
        :boolean     => { :name => "boolean" },
				:uuid => { :name => "binary", :limit => 16},
				:uuid_pkey => { :name => "binary(16) PRIMARY KEY NOT NULL"}
			}
	  end
	
		def quote(value, column = nil)
			if value.kind_of?(UUIDTools::UUID)
				"X'#{value.hexdigest}'"
			elsif value.kind_of?(String) && column && column.type == :uuid
				"X'#{UUIDTools::UUID.parse(value).hexdigest}'"
			else
        super
      end
    end	

#		def quote(value, column = nil)
#     if value.kind_of?(String) && column && column.type == :binary && column.class.respond_to?(:string_to_binary)
#        s = column.class.string_to_binary(value).unpack("H*")[0]
#        "x'#{s}'"
#      elsif value.kind_of?(BigDecimal)
#        value.to_s("F")
#      elsif value.kind_of?(UUIDTools::UUID)
#				"0x#{value.hexdigest()}"
#			else
#        super
#      end
#		end
	end
end