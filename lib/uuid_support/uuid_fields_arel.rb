module Arel::Visitors
	class SQLite
		def visit_UUIDTools_UUID o
			"X'#{o.hexdigest}'"
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
