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
      agent = "#{Connection.app}/#{Connection.version} (#{Connection.contact})"
      request.add_field("User-Agent", agent)

      response = http.request(request)
      return response.body
    end

    protected

    def self.get(source, search, linker = "AND", limit = 25, offset = 0)
      uri = URI("https://musicbrainz.org/ws/2/#{source}")
      if search.is_a?(Hash)
        params = { :query => Request.parse_params(search, linker),
                   :fmt => "json", :limit => limit, :offset => offset }
      else
        params = { :query => search, :fmt => "json" }
      end
      uri.query = URI.encode_www_form(params)
      return JSON.parse(self.request(uri))
    end

    def self.get_raw(source, search, linker = "AND", limit = 25, offset = 0)
      uri = URI("https://musicbrainz.org/ws/2/#{source}")
      if search.is_a?(Hash)
        params = { :query => Request.parse_params(search, linker),
                   :fmt => "json", :limit => limit, :offset => offset }
      else
        params = { :query => search, :fmt => "json" }
      end
      uri.query = URI.encode_www_form(params)
      return self.request(uri)
    end

    def self.lookup(source, id, sub_query = nil)
      uri = URI("https://musicbrainz.org/ws/2/#{source}/#{id}")
      params = {}
      params[:fmt] = "json"
      if !sub_query.nil?
        params[:inc] = sub_query
      end
      uri.query = URI.encode_www_form(params)
      return JSON.parse(self.request(uri))
    end

    def self.browse(source, search, id, limit = 25, offset = 0)
      uri = URI("https://musicbrainz.org/ws/2/#{source}")
      params = { search => id, :fmt => "json" }
      uri.query = URI.encode_www_form(params)
      return JSON.parse(self.request(uri))
    end
  end
end
