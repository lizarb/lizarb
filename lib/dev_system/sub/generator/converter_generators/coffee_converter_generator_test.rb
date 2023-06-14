class DevSystem::CoffeeConverterGeneratorTest < DevSystem::ConverterGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::CoffeeConverterGenerator
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
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
