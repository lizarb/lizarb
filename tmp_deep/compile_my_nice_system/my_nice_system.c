#include <ruby.h>

// MyNiceSystem::CalculatorMirror


static VALUE rb_m_my_nice_system__calculator_mirror_sum(VALUE self, VALUE a, VALUE b) {
    return rb_float_new(NUM2DBL(a) + NUM2DBL(b));
}

static VALUE rb_m_my_nice_system__calculator_mirror_subtract(VALUE self, VALUE a, VALUE b) {
    return rb_float_new(NUM2DBL(a) - NUM2DBL(b));
}

static VALUE rb_m_my_nice_system__calculator_mirror_multiply(VALUE self, VALUE a, VALUE b) {
    return rb_float_new(NUM2DBL(a) * NUM2DBL(b));
}

static VALUE rb_m_my_nice_system__calculator_mirror_divide(VALUE self, VALUE a, VALUE b) {
    return rb_float_new(NUM2DBL(a) / NUM2DBL(b));
}

static VALUE rb_m_my_nice_system__calculator_mirror_fibonacci(VALUE self, VALUE number) {
    int n = NUM2INT(number);
    if (n <= 1) {
        return INT2NUM(n);
    }
    return rb_funcall(self, rb_intern("fibonacci"), 1, INT2NUM(n - 1)) + rb_funcall(self, rb_intern("fibonacci"), 1, INT2NUM(n - 2));
}

static VALUE rb_m_my_nice_system__calculator_mirror_factorial(VALUE self, VALUE number) {
    int n = NUM2INT(number);
    if (n <= 1) {
        return INT2NUM(1);
    }
    return INT2NUM(n * NUM2INT(rb_funcall(self, rb_intern("factorial"), 1, INT2NUM(n - 1))));
}


// MyNiceSystem::SomethingNewMirror


// static VALUE ... new_connection

// static VALUE ... execute_query


// Initialization method for this module
void Init_my_nice_system(void) {



  // MyNiceSystem
  VALUE rb_cMyNiceSystem = rb_const_get(rb_cObject, rb_intern("MyNiceSystem"));
  


  // MyNiceSystem::CalculatorMirror

  VALUE rb_cMyNiceSystemCalculatorMirror = rb_const_get(rb_cMyNiceSystem, rb_intern("CalculatorMirror"));

  rb_define_singleton_method(rb_cMyNiceSystemCalculatorMirror, "sum", rb_m_my_nice_system__calculator_mirror_sum, 1);
  rb_define_singleton_method(rb_cMyNiceSystemCalculatorMirror, "subtract", rb_m_my_nice_system__calculator_mirror_subtract, 1);
  rb_define_singleton_method(rb_cMyNiceSystemCalculatorMirror, "multiply", rb_m_my_nice_system__calculator_mirror_multiply, 1);
  rb_define_singleton_method(rb_cMyNiceSystemCalculatorMirror, "divide", rb_m_my_nice_system__calculator_mirror_divide, 1);
  rb_define_singleton_method(rb_cMyNiceSystemCalculatorMirror, "fibonacci", rb_m_my_nice_system__calculator_mirror_fibonacci, 1);
  rb_define_singleton_method(rb_cMyNiceSystemCalculatorMirror, "factorial", rb_m_my_nice_system__calculator_mirror_factorial, 1);





  // MyNiceSystem::SomethingNewMirror

  VALUE rb_cMyNiceSystemSomethingNewMirror = rb_const_get(rb_cMyNiceSystem, rb_intern("SomethingNewMirror"));

  rb_define_method(rb_cMyNiceSystemSomethingNewMirror, "new_connection", rb_m_my_nice_system__something_new_new_connection, 1);
  rb_define_method(rb_cMyNiceSystemSomethingNewMirror, "execute_query", rb_m_my_nice_system__something_new_execute_query, 1);




}
