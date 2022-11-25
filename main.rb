require 'webrick'
require 'tofu'
require_relative 'src/app'

module Tofu
  class Context
    def res_add_cookie(name, value, expires=nil)
      value = WEBrick::HTTPUtils::escape(value)
      c = WEBrick::Cookie.new(name, value)
      c.expires = expires if expires
      c.path = req_script_name.to_s
      c.secure = true
      @res.cookies.push(c)
    end
  end
end

port = Integer(ENV['PORT']) rescue 8000
server = WEBrick::HTTPServer.new({
  :Port => port,
  :FancyIndexing => false
})

tofu = Tofu::Bartender.new(PoWo::Session, 'powo')
server.mount('/', Tofu::Tofulet, tofu)

trap(:INT){exit!}
server.start
