class DevSystem::RemoveGenerator < DevSystem::SimpleGenerator

  # liza g remove [controller] [filter]
  def call_default
    units = app_shell.sorted_writable_units.select { _1 < Controller and _1.superclass != Controller }

    params.expect 1, :string
    params.permit 2, :string
    name = params[1]
    type = params[2]

    if name
      c = Liza.const name
      units = units.select { _1 < c }
    end

    if type
      units = units.select { _1.to_s.snakecase.include? type }
    end

    units = pick_many_units units
    units = units.map { [_1, _1.test_class] rescue _1 }.flatten
    remove_units units
  end

end
