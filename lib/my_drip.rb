require 'open-uri'
require 'json'
require 'timeout'

class MyDrip
  def self.method_missing(name, *args)
    args =
      args.map {|arg|
      case arg
      when String
        "'#{arg}'"
      when Integer
        arg.to_s
      else
        '' 
      end
    }.join(',')
      code = "#{name}(#{args})"
      param = URI.encode("code=#{code}")
      res = JSON.parse(open('http://gateway.kitakee.net/my_drip?'+param).read)

      if res["status"] === "ok"
        res["result"]
      else
        super
      end
  end
end
