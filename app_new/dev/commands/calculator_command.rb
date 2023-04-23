class CalculatorCommand < NarrativeMethodCommand
  class Error < Error; end

  def self.sum(a, b)= a + b
  def self.sub(a, b)= a - b
  def self.mul(a, b)= a * b
  def self.div(a, b)= a / b

  # instance methods

  def validate
    log "Called #{self}.#{__method__}"
    raise Invalid, "liza calculator 0 + 0" if @args.size != 3

    @a  = @args[0].to_f
    @op = @args[1].to_sym
    @b  = @args[2].to_f

    log "@a  = #{@a}"
    log "@op = #{@op}"
    log "@b  = #{@b}"

    raise Invalid, "#{@op} is not a valid operator" unless [:+, :-, :*, :/].include? @op
  end

  def perform
    log "Called #{self}.#{__method__}"
    @result = \
      case @op
      when :+ then self.class.sum(@a, @b)
      when :- then self.class.sub(@a, @b)
      when :* then self.class.mul(@a, @b)
      when :/ then self.class.div(@a, @b)
      end
    log "RESULT: #{@result}"
    log render "success.txt"
  end

end

__END__

# view help.txt.erb

NAME:

  liza calculator

DESCRIPTION:

  Calculates the result of an arithmetic operation.

USAGE:

  liza calculator <a> <op> <b>

  where <a> and <b> are numbers and <op> is one of the following operators:

  +   addition
  -   subtraction
  *   multiplication
  /   division

EXAMPLES:

  liza calculator 1 + 2
  liza calculator 3 - 4
  liza calculator 5 * 6
  liza calculator 7 / 8
