module Arel::Visitors
	class SQLite
		def visit_UUIDTools_UUID o
			value = o.raw
			value.gsub(/\0|\%/n) do |b|
        case b
          when "\0" then "%00"
          when "%"  then "%25"
        end
      end
			visit_String(value)
		end

	end
end

module Arel::Visitors
	class MySQL
		
		def visit_UUIDTools_UUID o
			visit_String("0x#{o.hexdigest()}")
		end

	end
end

module Arel::Visitors
	class PostgreSQL
		
		def visit_UUIDTools_UUID o
			visit_String(o.to_s)
		end

	end
end
