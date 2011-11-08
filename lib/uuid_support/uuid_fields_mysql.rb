module ActiveRecord::ConnectionAdapters
	class MysqlAdapter
	  def native_database_types
			NATIVE_DATABASE_TYPES.merge({:uuid => { :name => "binary", :limit => 16}, :uuid_pkey => { :name => "binary(16) PRIMARY KEY"}})
	  end

		def quote(value, column = nil)
      if value.kind_of?(String) && column && column.type == :binary && column.class.respond_to?(:string_to_binary)
        s = column.class.string_to_binary(value).unpack("H*")[0]
        "x'#{s}'"
      elsif value.kind_of?(BigDecimal)
        value.to_s("F")
      elsif value.kind_of?(UUIDTools::UUID)
				"0x#{value.hexdigest()}"
			elsif value.kind_of?(String) && column && column.type == :uuid
				"0x#{UUIDTools::UUID.parse(value).hexdigest}"
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

class Arel::Visitors::Visitor
	def visit_UUIDTools_UUID o
		visit_String("0x#{o.hexdigest()}")
	end
end

module UUIDTools
  class UUID
    def quoted_id
      s = raw.unpack("H*")[0]
      "x'#{s}'"
    end
    
    def id
    	print "BLEAT"
    end  	
  end
end
