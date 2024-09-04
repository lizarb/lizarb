class AssetsRequest < AppRequest

  def self.call env
    super
    new.call env
  end

  def call env
    action = env["LIZA_ACTION"].to_sym
    format = env["LIZA_FORMAT"].to_sym

    #

    status = 200
    headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }
    body = ""

    body = render_action_admin_format_js  if action == :admin && format == :js
    body = render_action_admin_format_css if action == :admin && format == :css
    body = render_action_app_format_js    if action == :app   && format == :js
    body = render_action_app_format_css   if action == :app   && format == :css

    [status, headers, [body]]
  end

  # helper methods

  def render_action_admin_format_js
    "alert('it works')"
  end

  def render_action_admin_format_css
    "body { background: gray }"
  end

  def render_action_app_format_js
    <<-CODE
window.onload = () => {
  var h1 = document.createElement("h1");
  h1.setAttribute("style", "color: white");
  h1.innerHTML="JS file has been loaded. Random String: #{random_string}";
  document.body.append(h1);
}
    CODE
  end

  def render_action_app_format_css
    <<-CODE
body {
background: ##{random_color};
font-family: Roboto;
}
    CODE
  end

  def random_string
    Array("A".."z").sample(16).join
  end

  def random_color
    s = ""
    3.times do |i|
      s += Array(3..9).sample.to_s(16)
      s += "0"
    end
    s
  end

end
