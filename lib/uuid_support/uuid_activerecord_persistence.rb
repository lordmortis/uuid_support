module ActiveRecord
	module Persistence

    def create
      if self.id.nil?
        if (self.column_for_attribute(:id).type == :uuid || self.column_for_attribute(:id).type == :uuid_pkey)
          self.id = UUIDTools::UUID.timestamp_create
        end
      end

      attributes_values = arel_attributes_values(!id.nil?)

      new_id = self.class.unscoped.insert attributes_values

      self.id ||= new_id

      IdentityMap.add(self) if IdentityMap.enabled?
      @new_record = false
      id
    end
  end
end