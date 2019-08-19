require_relative "./request.rb"

module MusicBrainz2
  class Alias
    public

    attr_accessor :name, :locale, :type, :primary, :begin_date, :end_date

    def parse(hash)
      @name = hash["name"]
      @locale = hash["locale"]
      @type = hash["type"]
      @primary = hash["primary"]
      @begin_date = hash["begin-date"]
      @end_date = hash["end-date"]
    end
  end

  class Annotation
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("annotation", data, linker)
      @results = res["annotations"]
      return @results
    end
  end

  class Area
    include Request

    public

    attr_accessor :id, :name, :sort_name

    def self.search(data, linker = "AND")
      res = Request.get("area", data, linker)
      @results = res["areas"]
      return @results
    end

    def parse(hash)
      @id = hash["id"]
      @name = hash["name"]
      @sort_name = hash["sort-name"]
    end
  end

  class Artist
    include Request

    public

    attr_accessor :id, :name, :sort_name, :aliases

    def self.search(data, linker = "AND")
      res = Request.get("artist", data, linker)
      @results = res["artists"]
      return @results
    end

    def parse(hash)
      @id = hash["id"]
      @name = hash["name"]
      @sort_name = hash["sort-name"]
      if hash["aliases"] != nil
        @aliases = []
        hash["aliases"].each do |h|
          al = Alias.new
          al.parse(h)
          @aliases.push(al)
        end
      else
        @aliases = nil
      end
    end
  end

  class CDStub
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("cdstub", data, linker)
      @results = res["cdstubs"]
      return @results
    end
  end

  class Event
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("event", data, linker)
      @results = res["events"]
      return @results
    end
  end

  class Instrument
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("instrument", data, linker)
      @results = res["instruments"]
      return @results
    end
  end

  class Label
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("label", data, linker)
      @results = res["labels"]
      return @results
    end
  end

  class Media
    public

    attr_accessor :position, :format, :track_count, :track_offset

    def parse(hash)
      @position = hash["position"]
      @format = hash["format"]
      @track_count = hash["track-count"]
      @track_offset = hash["track-offset"]
    end
  end

  class Place
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("place", data, linker)
      @results = res["places"]
      return @results
    end
  end

  class Recording
    include Request

    public

    def initialize
    end

    attr_accessor :id, :artist, :artists, :title, :duration, :releases

    def self.search(data, linker = "AND")
      res = Request.get("recording", data, linker)
      return res["recordings"]
    end

    def search()
      params = {}
      if !@artist.to_s.empty?
        params[:artist] = @artist
      end
      if !@title.to_s.empty?
        params[:recording] = @title
      end
      if !@duration.to_s.empty?
        params[:dur] = @duration
      end
      res = Request.get("recording", params)
      return res["recordings"]
    end

    def parse(hash)
      @id = hash["id"]
      @title = hash["title"]
      @artists = []
      hash["artist-credit"].each do |h|
        a = Artist.new
        a.parse(h["artist"])
        @artists.push(a)
      end
      @duration = hash["length"]
      @releases = []
      hash["releases"].each do |h|
        r = Release.new
        r.parse(h)
        @releases.push(r)
      end
    end
  end

  class ReleaseEvent
    public

    attr_accessor :date, :area

    def parse(hash)
      @date = hash["date"]
      @area = Area.new
      @area.parse(hash["area"])
    end
  end

  class ReleaseGroup
    include Request

    public

    attr_accessor :id, :type_id, :title, :primary_type

    def self.search(data, linker = "AND")
      res = Request.get("release-group", data, linker)
      @results = res["release-groups"]
      return @results
    end

    def parse(hash)
      @id = hash["id"]
      @type_id = hash["type-id"]
      @title = hash["title"]
      @primary_type = hash["primary-type"]
    end
  end

  class Release
    include Request

    public

    attr_accessor :id, :title, :artist, :release_group, :track_count, :media
    attr_accessor :date, :country, :release_events

    def self.search(data, linker = "AND")
      res = Request.get("release", data, linker)
      @results = res["releases"]
      return @results
    end

    def parse(hash)
      @id = hash["id"]
      @title = hash["title"]
      @track_count = hash["track-count"]
      @date = hash["date"]
      @country = hash["country"]
      @artist = []
      hash["artist-credit"].each do |h|
        a = Artist.new
        a.parse(h)
        @artist.push(a)
      end
      rg = ReleaseGroup.new
      rg.parse(hash["release-group"])
      @release_group = rg
      @release_events = []
      hash["release-events"].each do |h|
        @release_events.push(h)
      end
    end
  end

  class Series
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("series", data, linker)
      @results = res["series"]
      return @results
    end
  end

  class Tag
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("tag", data, linker)
      @results = res["tags"]
      return @results
    end
  end

  class Track
    public

    attr_accessor :id, :number, :title, :length

    def parse(hash)
      @id = hash["id"]
      @number = hash["id"]
      @title = hash["title"]
      @length = hash["length"]
    end
  end

  class Url
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("url", data, linker)
      @results = res["urls"]
      return @results
    end
  end

  class Work
    include Request

    public

    def self.search(data, linker = "AND")
      res = Request.get("work", data, linker)
      @results = res["works"]
      return @results
    end
  end
end
