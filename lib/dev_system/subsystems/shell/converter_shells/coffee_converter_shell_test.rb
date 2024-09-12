class DevSystem::CoffeeConverterShellTest < DevSystem::ConverterShellTest

  test :subject_class do
    assert subject_class == DevSystem::CoffeeConverterShell
  end

  test :convert do
    test_convert <<-COFFEESCRIPT, <<-JAVASCRIPT
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
  end

end
