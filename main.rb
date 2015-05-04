
require 'net/http'
require 'json'
require 'erb'

require './Servlets.rb'
include Servlets

##
# This app contains WEBRick configuraion, Servlets and script for
# starting server
# later Servlerts will be moved to separate folder
# Update: they where moved

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
