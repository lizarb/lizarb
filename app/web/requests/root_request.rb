class RootRequest < AppRequest

  # NOTE: There's a bug in this file. Can you find it?
  def self.call env
    action = env["LIZA_ACTION"]

    #

    @status = 200

    @headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }

    @body = ""

    if action == "index"
      render_action_index
    else
      @status = 404
      render_action_not_found action
    end

    [@status, @headers, [@body]]
  rescue => e
    @status = 500
    @body = "#{e.class} - #{e.message}"

    log @status
    [@status, @headers, [@body]]
  end

  def self.render_action_index
    h1 = "Ruby Works!"

    @body = <<~CODE
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

  def self.render_action_not_found action
    @body = "Ruby couldn't find your page! action: #{action}"
  end

end
