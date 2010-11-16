class ActiveRecord::ConnectionAdapters::TableDefinition
  %w( uuid uuid_pkey ).each do |column_type|
    class_eval <<-EOV, __FILE__, __LINE__ + 1
      def #{column_type}(*args)                                               # def string(*args)
        options = args.extract_options!                                       #   options = args.extract_options!
        column_names = args                                                   #   column_names = args
                                                                              #
        column_names.each { |name| column(name, '#{column_type}', options) }  #   column_names.each { |name| column(name, 'string', options) }
      end                                                                     # end
    EOV
  end
end

module ActiveRecord::ConnectionAdapters::SchemaStatements
	def type_to_sql(type, limit = nil, precision = nil, scale = nil) #:nodoc:
		print("SchemaStatements: Type is: #{type}\n")
	  if native = native_database_types[type]
	    column_type_sql = (native.is_a?(Hash) ? native[:name] : native).dup

	    if type == :decimal # ignore limit, use precision and scale
	      scale ||= native[:scale]

	      if precision ||= native[:precision]
	        if scale
	          column_type_sql << "(#{precision},#{scale})"
	        else
	          column_type_sql << "(#{precision})"
	        end
	      elsif scale
	        raise ArgumentError, "Error adding decimal column: precision cannot be empty if scale if specified"
	      end

	    elsif (type != :primary_key) && (limit ||= native.is_a?(Hash) && native[:limit])
	      column_type_sql << "(#{limit})"
	    end

	    column_type_sql
	  else
	    type
	  end
	end
end

class ActiveRecord::ConnectionAdapters::Column
  # Returns the Ruby class that corresponds to the abstract data type.
  def klass
    case type
      when :integer       then Fixnum
      when :float         then Float
      when :decimal       then BigDecimal
      when :datetime      then Time
      when :date          then Date
      when :timestamp     then Time
      when :time          then Time
      when :text, :string then String
      when :binary        then String
      when :boolean       then Object
			when :uuid					then UUIDTools::UUID
    end
  end

  # Casts value (which is a String) to an appropriate instance.
  def type_cast(value)
    return nil if value.nil?
    case type
      when :string    then value
      when :text      then value
      when :integer   then value.to_i rescue value ? 1 : 0
      when :float     then value.to_f
      when :decimal   then self.class.value_to_decimal(value)
      when :datetime  then self.class.string_to_time(value)
      when :timestamp then self.class.string_to_time(value)
      when :time      then self.class.string_to_dummy_time(value)
      when :date      then self.class.string_to_date(value)
      when :binary    then self.class.binary_to_string(value)
      when :boolean   then self.class.value_to_boolean(value)
			when :uuid			then self.class.string_to_uuid(value)
      else value
    end
  end

  def type_cast_code(var_name)
    case type
      when :string    then nil
      when :text      then nil
      when :integer   then "(#{var_name}.to_i rescue #{var_name} ? 1 : 0)"
      when :float     then "#{var_name}.to_f"
      when :decimal   then "#{self.class.name}.value_to_decimal(#{var_name})"
      when :datetime  then "#{self.class.name}.string_to_time(#{var_name})"
      when :timestamp then "#{self.class.name}.string_to_time(#{var_name})"
      when :time      then "#{self.class.name}.string_to_dummy_time(#{var_name})"
      when :date      then "#{self.class.name}.string_to_date(#{var_name})"
      when :binary    then "#{self.class.name}.binary_to_string(#{var_name})"
      when :boolean   then "#{self.class.name}.value_to_boolean(#{var_name})"
			when :uuid			then "#{self.class.name}.string_to_uuid(#{var_name})"
      else nil
    end
  end

	def uuid?
		(type == :uuid)
	end
end