class MyNiceSystem::CalculatorMirror < DeepSystem::C1Mirror

  # below, an example of getting an instance variable
  # cdef :sum, :other, <<-CLANG
  #   VALUE value = rb_iv_get(self, "@value");
  #   return rb_float_new(NUM2DBL(value) + NUM2DBL(other));
  # CLANG

  cdef_self :sum, :a, :b, <<-CLANG
    return rb_float_new(NUM2DBL(a) + NUM2DBL(b));
  CLANG

  cdef_self :subtract, :a, :b, <<-CLANG
    return rb_float_new(NUM2DBL(a) - NUM2DBL(b));
  CLANG

  cdef_self :multiply, :a, :b, <<-CLANG
    return rb_float_new(NUM2DBL(a) * NUM2DBL(b));
  CLANG

  cdef_self :divide, :a, :b, <<-CLANG
    return rb_float_new(NUM2DBL(a) / NUM2DBL(b));
  CLANG

  cdef_self :fibonacci, :number, <<-CLANG
    int i = NUM2INT(number);
    if (n <= 1) {
      return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
  CLANG

  cdef_self :factorial, :number, <<-CLANG
    int i = NUM2INT(number);
    if (n <= 1) {
      return 1;
    }
    return n * factorial(n - 1);
  CLANG

end
