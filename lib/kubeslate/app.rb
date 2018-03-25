require "kubeslate/info"

module Kubeslate
  class App
    def initialize
      @info = Info.new
    end

    def call(env)
      [200, headers, content]
    end


    def content
      [
        "<!DOCTYPE html>",
        "<html>",
        "<head>",
        "<style>",
        "body { background: #3371e3; color: white;  font-family: sans-serif; }",
        "table { padding: 1em; border: black; border-style: solid; clear: left; }",
        "th, td { padding: 0 1em; }",
        ".logo { position: relative; display: block; float: left; width: 180px; height: 88px; transform: none; background-image: url(https://kubernetes.io/images/nav_logo.svg); background-size: contain; background-position: center center; background-repeat: no-repeat; margin-right: 1em;}",
        ".version { padding-top: 40px; }",
        "</style>",
        "</head>",
        "<body>",
        "<a href=\"https://kubernetes.io\" class=\"logo\"></a>",
        "<div class=\"version\">#{@info.version.git_version}</div>",
        "<table>",
        "<tr>",
        "<th>Pods</th>",
        "<th>Services</th>",
        "<th>Deployments</th>",
        "</tr>",
        "<tr>",
        "<td>#{@info.pod_count}</td>",
        "<td>#{@info.service_count}</td>",
        "<td>#{@info.deployment_count}</td>",
        "</tr>",
        "</body>",
        "</html>",
      ]
    end

    def headers
      {
        Rack::CONTENT_TYPE   => "text/html",
        Rack::CONTENT_LENGTH => content.join.length,
      }
    end
  end
end
