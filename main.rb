require 'webrick'
require 'tofu'
require_relative 'src/app'

port = Integer(ENV['PORT']) rescue 8000
server = WEBrick::HTTPServer.new({
  :Port => port,
  :FancyIndexing => false
})

tofu = Tofu::Bartender.new(PoWo::Session, 'powo')
server.mount('/', Tofu::Tofulet, tofu)

trap(:INT){exit!}
server.start
