class DeepSystem::MirrorCommand < DevSystem::SimpleCommand

  section :actions

  # liza mirror s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_default
    call_compile
    call_invoke
  end

  def call_compile
    log stick :b, system.color, "I just think Ruby is the Best for coding!"
    sleep 0.1
    sleep 0.1
    sleep 0.2

    # compile_controllers
    log "compile controllers"
    # compile_systems
    log "compile systems"
  end

  def call_invoke
    log stick :b, system.color, "I just think Ruby is the Best for coding!"
    sleep 0.1
    sleep 0.1
    sleep 0.2

    log "CalculatorMirror.sum(1, 2) => #{CalculatorMirror.sum(1, 2)}"
    log "CalculatorMirror.subtract(5, 3) => #{CalculatorMirror.subtract(5, 3)}"
    log "CalculatorMirror.multiply(4, 6) => #{CalculatorMirror.multiply(4, 6)}"
    log "CalculatorMirror.divide(8, 2) => #{CalculatorMirror.divide(8, 2)}"
    log "CalculatorMirror.fibonacci(10) => #{CalculatorMirror.fibonacci(10)}"
    log "CalculatorMirror.factorial(5) => #{CalculatorMirror.factorial(5)}"

    mirror = SomethingNewMirror.new
    log "mirror => #{mirror}"
    log "mirror.new_connection('credentials') => #{mirror.new_connection('credentials')}"
    log "mirror.execute_query('SELECT * FROM table') => #{mirror.execute_query('SELECT * FROM table')}"
  end

end
