class DevSystem::RemoveGenerator < DevSystem::SimpleGenerator
  
  # liza g remove [controller] [filter]
  
  def call_default
    units = app_shell.sorted_writable_units.select { _1 < Controller and _1.superclass != Controller }

    a_filter = Array command.simple_args[1..2]

    if a_filter[0]
      c = Liza.const a_filter[0]
      units = units.select { _1 < c }
    end

    if a_filter[1]
      units = units.select { _1.to_s.snakecase.include? a_filter[1] }
    end

    units = pick_many_units units
    units = units.map { [_1, _1.test_class] rescue _1 }.flatten
    remove_units units
  end

end
