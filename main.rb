require 'webrick'
require 'net/http'
require 'json'
require 'erb'
require './FileManager.rb'
#:include:FileManager.rb
##
# This app contains WEBRick configuraion, Servlets and script for
# starting server
# later Servlerts will be moved to separate folder

##
# class Inf
#  Inf pourpuse is to provide methods and variables for parsing rhtml file
#  currently it conains hardcoded rhtml file, but later i hope to do something about it

class Inf
  include ERB::Util
   attr_accessor :json, :url
   ##
   # constructor for class Inf
   # @param json - json string form e621.net/post/show.json api
   # @url variable is not needed, but it's nice and cute to have.
  def initialize(json)
    @json = JSON.parse(json).to_hash
    @url = @json['file_url']
  end
  ##
  # render() - function for parsing rhtml file

  def render()
    ERB.new(File.read("webroot/tmp_resp.rhtml")).result(binding)
  end

end
##
# Simple class - WEBrick servlet for retriving json data from e621.net/post/show api
# response body is parsed  rhtml file webroot/tmp_resp.rhtml

class Simple < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    status, content_type, body = save_answers(request)

     response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def save_answers(request)

    uri = URI("https://e621.net/post/show.json?md5=#{request.query['md5']}")
    pom = Net::HTTP.get(uri)
    p = Inf.new(pom)

  return 200, 'text/html', p.render()
  end
end
##
# Dirs class - Servlet for file managing on host computer
# It's job is to provide methods for using FileManager module
class Dirs < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    status, content_type, body = save_answers(request)

     response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def save_answers(request)
    dir = request.query['folder']

    elems = Dir[File.absolute_path(dir) + "/*"]



      return 200, 'text/html', elems.to_s
  end
end
#setting up WEBrick variables
root = './webroot'
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root
trap 'INT' do server.shutdown end
# Mounting requests
server.mount '/', WEBrick::HTTPServlet::FileHandler, './webroot'
server.mount '/pom', Simple
server.mount '/dire', Dirs
#starting server
puts "server is starting"
server.start
