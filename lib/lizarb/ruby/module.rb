# frozen_string_literal: true

class Module

  # ["/path/to/liza.rb", 1]
  def source_location
    Array Object.const_source_location name
  end

  # "/path/to/liza.rb"
  def source_location_path
    source_location[0]
  rescue
    nil
  end

  # "/path/to/liza"
  def source_location_radical
    source_location_path[0..-4]
  rescue
    nil
  end

end
