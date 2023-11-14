class BusinessLogicShell < DevSystem::Shell
  # class Error < Liza::Error; end
  # class CustomError < Error; end

  # BusinessLogicShell.metric_bmi 70, 180

  def self.metric_bmi(kilograms, centimenters)
    log "kilograms = #{kilograms.inspect}"
    log "centimenters = #{centimenters.inspect}"
    bmi = nil

    bmi = kilograms / ((centimenters / 100.0) ** 2)
    log "bmi = #{bmi.inspect}"
    
    bmi
  end

  # BusinessLogicShell.imperial_bmi 154, 70

  def self.imperial_bmi(pounds, inches)
    log "pounds = #{pounds.inspect}"
    log "inches = #{inches.inspect}"

    kilograms = pounds_to_kilograms pounds
    centimenters = inches_to_centimeters inches

    metric_bmi kilograms, centimenters
  end

  # BusinessLogicShell.pounds_to_kilograms 154

  def self.pounds_to_kilograms(pounds)
    pounds * 0.45
  end

  # BusinessLogicShell.inches_to_centimeters 70

  def self.inches_to_centimeters(inches)
    inches * 2.54
  end
  
end
