class QuadraticCommand < NarrativeMethodCommand
  class Error < Error; end

  def self.quadratic(a, b, c)
    d = b**2 - 4 * a * c
    case
    when d < 0
      []
    when d == 0
      [-b / (2 * a)]
    else
      [(-b + Math.sqrt(d)) / (2 * a), (-b - Math.sqrt(d)) / (2 * a)].sort
    end
  end

  # instance methods

  def validate
    log "Called #{self}.#{__method__}"
    raise Invalid, "liza quadratic 0 0 0" if @args.size != 3

    @a = @args[0].to_f
    @b = @args[1].to_f
    @c = @args[2].to_f

    log "@a = #{@a}"
    log "@b = #{@b}"
    log "@c = #{@c}"

    raise Invalid, "a can't be zero" if @a == 0
  end

  def perform
    log "Called #{self}.#{__method__}"

    @result = self.class.quadratic(@a, @b, @c)
    log "RESULT: #{@result}"
    log render "success.txt"
  end

end

__END__

# view help.txt.erb

NAME:

  liza quadratic

DESCRIPTION:

  Calculates the result of a quadratic equation.

USAGE:

  liza quadratic <a> <b> <c>

  where <a>, <b> and <c> are numbers.

EXAMPLES:

  liza quadratic 1 0 0
  liza quadratic 1 0 1
  liza quadratic 1 1 1
  liza quadratic 1 2 1
