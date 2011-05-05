module ActiveRecord
	module Persistence
		def create
			if self.id.nil?
				if (self.column_for_attribute(:id).type == :uuid)
					self.id = UUIDTools::UUID.timestamp_create
				end
			end
			
      if self.id.nil? && connection.prefetch_primary_key?(self.class.table_name)
        self.id = connection.next_sequence_value(self.class.sequence_name)
      end

      attributes_values = arel_attributes_values

      new_id = if attributes_values.empty?
        self.class.unscoped.insert connection.empty_insert_statement_value
      else
        self.class.unscoped.insert attributes_values
      end

      self.id ||= new_id

      @new_record = false
      id
		end
	end
end