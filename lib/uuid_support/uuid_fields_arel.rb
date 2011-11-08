module UUIDTools
  class UUID

    def as_json(options = nil)
      hexdigest.upcase
    end

    def to_param
      hexdigest.upcase
    end
  end
end
