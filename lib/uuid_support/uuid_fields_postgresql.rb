module ActiveRecord::ConnectionAdapters
	class PostgreSQLAdapter
	  def native_database_types
			NATIVE_DATABASE_TYPES.merge({:uuid => { :name => "uuid"}, :uuid_pkey => { :name => "uuid primary key"}})
	  end

		def quote(value, column = nil)
      return super unless column

      case value
      when Numeric
        return super unless column.sql_type == 'money'
        # Not truly string input, so doesn't require (or allow) escape string syntax.
        "'#{value}'"
			when UUIDTools::UUID
				"'#{value.to_s}'"
      when String
        case column.sql_type
        when 'bytea' then "'#{escape_bytea(value)}'"
        when 'xml'   then "xml '#{quote_string(value)}'"
        when /^bit/
          case value
          when /^[01]*$/      then "B'#{value}'" # Bit-string notation
          when /^[0-9A-F]*$/i then "X'#{value}'" # Hexadecimal notation
          end
        else
          super
        end
      else
        super
      end
    end
	end
	
	class PostgreSQLColumn
		class << self
			def string_to_uuid(value)
				if (value.class == String)
					UUIDTools::UUID.parse(value)
				else
					value
				end					
			end
		end
				
		def simplified_type(field_type)
      case field_type
        # Numeric and monetary types
        when /^(?:real|double precision)$/
          :float
        # Monetary types
        when 'money'
          :decimal
        # Character types
        when /^(?:character varying|bpchar)(?:\(\d+\))?$/
          :string
        # Binary data types
        when 'bytea'
          :binary
        # Date/time types
        when /^timestamp with(?:out)? time zone$/
          :datetime
        when 'interval'
          :string
        # Geometric types
        when /^(?:point|line|lseg|box|"?path"?|polygon|circle)$/
          :string
        # Network address types
        when /^(?:cidr|inet|macaddr)$/
          :string
        # Bit strings
        when /^bit(?: varying)?(?:\(\d+\))?$/
          :string
        # XML type
        when 'xml'
          :xml
        # Arrays
        when /^\D+\[\]$/
          :string
        # Object identifier types
        when 'oid'
          :integer
        # UUID type
        when 'uuid'
          :uuid
        # Small and big integer types
        when /^(?:small|big)int$/
          :integer
        # Pass through all types that are not specific to PostgreSQL.
        else
          super
      end
		end	
	end
	
end