require "net/http"
require "json"

uri = URI("https://musicbrainz.org/ws/2/artist")
params = { :query => "Amaranthe", :fmt => "json", :"User-Agent" => "test-agent/0.1" }
uri.query = URI.encode_www_form(params)

# res = Net::HTTP.get_response(uri)
# puts res.body
#
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

request = Net::HTTP::Get.new(uri.request_uri)
request.add_field("User-Agent", "My User Agent Dawg")

response = http.request(request)
json = response.body
puts json
object = JSON.parse(json, object_class: OpenStruct)
puts object.artists[0].name

# req = Net::HTTP::Get.new(uri)
# req.add_field("User-Agent", "My User Agent Dawg")
# res = Net::HTTP.start(uri.host, uri.port) { |http| http.use_ssl = true; http.request(req) }
# puts res.body
