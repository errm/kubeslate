$:.unshift(File.expand_path("../lib", __FILE__)) 
require "kubeslate/app"
require "rack/health"

use Rack::CommonLogger
use Rack::Health, :path => "/healthz"
run Kubeslate::App.new
