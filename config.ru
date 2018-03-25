$:.unshift(File.expand_path("../lib", __FILE__)) 
require "kubeslate/app"

run Kubeslate::App.new
