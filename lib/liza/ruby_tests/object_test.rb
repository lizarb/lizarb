class Liza::ObjectTest < Liza::Test

  def self.subject_class
    @subject_class ||= Object.const_get last_namespace[0..-5]
  end

end
