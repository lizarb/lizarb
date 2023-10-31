class DevSystem::CoffeeConverterShellTest < DevSystem::ConverterShellTest

  test :subject_class do
    assert subject_class == DevSystem::CoffeeConverterShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test :convert do
    coffeescript, javascript = <<-COFFEESCRIPT, <<-JAVASCRIPT
listen = (el, event, handler) ->
  if el.addEventListener
    el.addEventListener event, handler
  else
    el.attachEvent 'on' + event, ->
      handler.call el

COFFEESCRIPT
(function() {
  var listen;

  listen = function(el, event, handler) {
    if (el.addEventListener) {
      return el.addEventListener(event, handler);
    } else {
      return el.attachEvent('on' + event, function() {
        return handler.call(el);
      });
    }
  };

}).call(this);
JAVASCRIPT

    output = subject_class.convert coffeescript
    assert_equality output, javascript
  end

end
