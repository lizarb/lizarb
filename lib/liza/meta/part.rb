class Liza::Part < Liza::Unit
  def self.insertion &block
    if block_given?
      @insertion = block
    else
      @insertion
    end
  end

  def self.extension &block
    if block_given?
      @extension = block
    else
      @extension
    end
  end
end
