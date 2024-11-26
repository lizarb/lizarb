class Liza::Part < Liza::Unit
  
  section :unit

  def self.color() = system.color

  section :default

  # A hash of insertions.
  # @return [Hash]
  def self.insertions() = @insertions ||= {}

  # Define or retrieve an insertion.
  # @param name [Symbol] The name of the insertion.
  # @param block [Proc] The block to insert.
  # @return [Proc]
  def self.insertion(name=:default, &block)
    if block_given?
      insertions[name] = block
    else
      insertions[name]
    end
  end

end
