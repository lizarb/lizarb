class Liza::Part < Liza::Unit
  
  def self.insertion &block
    if block_given?
      @insertion = block
    else
      @insertion
    end
  end

end
