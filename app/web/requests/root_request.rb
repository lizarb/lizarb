class RootRequest < AppRequest

  # NOTE: There's a bug in this file. Can you find it?
  def self.call menv
    super
    action = menv["LIZA_ACTION"]

    #

    menv[:response_status] = 200

    menv[:response_headers] = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }

    menv[:response_body] = ""

    if action == "index"
      render_action_index menv
    else
      menv[:response_status] = 404
      render_action_not_found action, menv
    end

  rescue => e
    menv[:response_status] = 500
    menv[:response_body] = "#{e.class} - #{e.message}"
    log menv[:response_status]
  end

  def self.render_action_index(menv)
    h1 = "Ruby Works!"

    menv[:response_body] = <<~CODE
<html>
<head>
  <title>Ruby</title>
  <link rel="stylesheet" href="/assets/app.css" />
  <script type="application/javascript" src="/assets/app.js"></script>
</head>
<body>
  <h1>#{h1}</h1>
</body>
</html>
    CODE
  end

  def self.render_action_not_found action, menv
    menv[:response_body] = "Ruby couldn't find your page! action: #{action}"
  end

end
