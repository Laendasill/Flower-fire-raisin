require 'webrick'
require './FileManager.rb'
# Servlets moodule - Namespace for WEBrick servlets 
module Servlets 
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
		include FileManager
	  def do_GET request, response
		status, content_type, body = process_request(request)

		 response.status = status
		response['Content-Type'] = content_type
		response.body = body
	  end
		
		def do_POST request, response
			body = "Error?"
			if request.query['get_dir'] = "current"
				body = Dir.pwd
			else
				
			end
			
			response.status = 200
			response['Content-Type'] = 'text/html'
			response.body = body
			
			
		end
		
		def process_request(request)
			
			if request.query['init'] == 'y'
				elem = Dir.pwd
			end
			dir = request.query['folder']

			elems = Dir[File.absolute_path(dir) + "/*"]



		  return 200, 'text/html', elems.to_s
	  end
	end
end