require "net/http"
require "json"

module MusicBrainz2
  module Request
    private

    def self.parse_params(params, linker = "AND")
      data = ""
      (0..params.length - 1).step(1) do |i|
        data += "#{params.keys[i].to_s}:\"#{params.values[i]}\" #{linker} "
      end
      data.delete_suffix!(" #{linker} ")
      return data
    end

    def self.request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      agent = "#{Connection.agent}/#{Connection.version} (#{Connection.contact})"
      request.add_field("User-Agent", agent)

      response = http.request(request)
      res = response.body
      object = JSON.parse(res)
      return object
    end

    protected

    def self.get(source, search, linker = "AND", limit = 25)
      uri = URI("https://musicbrainz.org/ws/2/#{source}")
      if search.is_a?(Hash)
        params = { :query => Request.parse_params(search, linker),
                   :fmt => "json", :limit => limit }
      else
        params = { :query => search, :fmt => "json" }
      end
      uri.query = URI.encode_www_form(params)
      return self.request(uri)
    end

    def self.find(id)
    end
  end
end
