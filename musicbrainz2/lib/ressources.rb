require_relative "./request.rb"

module MusicBrainz2
  class Ressource
    public

    def initialize(arg = nil)
      if arg.is_a?(Hash)
        self.parse(arg)
      end
    end

    def parse(hash)
      raise "You can not initialize this abstract class!"
    end
  end

  class Alias < Ressource
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

  class Area < Ressource
    include Request

    public

    attr_accessor :id, :name, :sort_name, :iso_codes
    def self.search(data, linker = "AND")
      res = Request.get("area", data, linker)
      @results = res["areas"]
      return @results
    end

    def parse(hash)
      @id = hash["id"]
      @name = hash["name"]
      @sort_name = hash["sort-name"]
      @iso_codes = []
      if !hash["iso-3166-1-codes"].nil?
        hash["iso-3166-1-codes"].each do |h|
          @iso_codes.push(h)
        end
      end
    end
  end

  class Artist < Ressource
    include Request

    public

    attr_accessor :id, :name, :sort_name, :aliases, :tags, :area, :begin_area

    def self.search(data, linker = "AND")
      res = Request.get("artist", data, linker)
      @results = res["artists"]
      return @results
    end

    def search()
      params = {}
      if !@name.nil?
        params[:name] = @name
      end
      res = Request.get("artist", params)
      @results = res["artists"]
      return @results
    end

    def parse(hash)
      @id = hash["id"]
      @name = hash["name"]
      @sort_name = hash["sort-name"]
      if !hash["aliases"].nil?
        @aliases = []
        hash["aliases"].each do |h|
          @aliases.push(Alias.new(h))
        end
      end
      if !hash["area"].nil?
        @area = Area.new(hash["area"])
      end
      if !hash["begin-area"].nil?
        @begin_area = Area.new(hash["begin-area"])
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

  class Media < Ressource
    public

    attr_accessor :position, :format, :track_count, :track_offset, :track

    def parse(hash)
      @position = hash["position"]
      @format = hash["format"]
      @track_count = hash["track-count"]
      @track_offset = hash["track-offset"]
      @track = []
      if !hash["track"].nil?
        hash["track"].each do |h|
          @track.push(Track.new(h))
        end
      end
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

    attr_accessor :id, :artist, :artists, :title, :duration, :releases, :video

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
      @video = hash["video"]
      @artists = []
      hash["artist-credit"].each do |h|
        @artists.push(Artist.new(h))
      end
      @duration = hash["length"]
      @releases = []
      if !hash["releases"].nil?
        hash["releases"].each do |h|
          @releases.push(Release.new(h))
        end
      end
    end
  end

  class ReleaseEvent < Ressource
    public

    attr_accessor :date, :area

    def parse(hash)
      @date = hash["date"]
      @area = Area.new(hash["area"])
    end
  end

  class ReleaseGroup < Ressource
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

  class Release < Ressource
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
        @artist.push(Artist.new(h))
      end
      @release_group = ReleaseGroup.new(hash["release-group"])
      @release_events = []
      if !hash["release-events"].nil?
        hash["release-events"].each do |h|
          @release_events.push(ReleaseEvent.new(h))
        end
      end
      @media = []
      if !hash["media"].nil?
        hash["media"].each do |h|
          @media.push(Media.new(h))
        end
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

  class Tag < Ressource
    include Request

    public

    attr_reader :count, :name

    def self.search(data, linker = "AND")
      res = Request.get("tag", data, linker)
      @results = res["tags"]
      return @results
    end

    def parse(hash)
      @count = hash["count"]
      @name = hash["name"]
    end
  end

  class Track < Ressource
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
