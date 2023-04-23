class CircleCommand < NarrativeMethodCommand
  class Error < Error; end

  def self.area(radius)
    log "Called #{self}.#{__method__} with radius #{radius}"
    log "The answer is #{radius**2}π"
    Math::PI * radius**2
  end

  def self.circumference(radius)
    log "Called #{self}.#{__method__} with radius #{radius}"
    log "The answer is #{radius * 2}π"
    2 * Math::PI * radius
  end

  # instance methods

  def validate
    log "Called #{self}.#{__method__}"
    raise Invalid, "liza circle <formula> <radius>" if @args.size != 2
    raise Invalid, "liza circle <formula> <radius>" if @args[0] != "area" && @args[0] != "circumference"

    @formula = @args[0].to_sym
    @radius = @args[1].to_f

    log "@formula = #{@formula}"
    log "@radius  = #{@radius}"

    raise Invalid, "radius must be greater than 0" if @radius <= 0
  end

  def perform
    log "Called #{self}.#{__method__}"

    @result = \
      case @formula
      when :area          then self.class.area(@radius)
      when :circumference then self.class.circumference(@radius)
      end
    log "RESULT: #{@result}"
    log render "success.txt"
  end

end

__END__

# view help.txt.erb

NAME:

  liza circle

DESCRIPTION:

  Calculates a circle formula based on the radius.

USAGE:

  liza circle <formula> <radius>

FORMULAS:

  area          - calculates the area of a circle
  circumference - calculates the circumference of a circle

EXAMPLES:

  liza circle area 5
  liza circle circumference 5
