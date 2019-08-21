require_relative "./request.rb"

module MusicBrainz2
  class Ressource
    protected

    attr_accessor :fields

    public

    def initialize(arg = nil)
      @fields = {}
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

    attr_reader :name, :locale, :type, :primary, :begin_date, :end_date

    def parse(hash)
      @name = hash["name"]
      @locale = hash["locale"]
      @type = hash["type"]
      @primary = hash["primary"]
      @begin_date = hash["begin-date"]
      @end_date = hash["end-date"]
    end
  end

  class Annotation < Ressource
    include Request

    public

    attr_accessor :s_type, :s_entity, :s_name, :s_text
    attr_reader :type, :entity, :name, :text

    def self.search(data, linker = "AND")
      res = Request.get("annotation", data, linker)
      @results = res["annotations"]
      return @results
    end

    def search()
      @fields[:type] = @s_type if !@s_type.nil?
      @fields[:entity] = @s_entity if !@s_entity.nil?
      @fields[:name] = @s_name if !@s_name.nil?
      @fields[:text] = @s_text if !@s_text.nil?
      return Request.get("annotation", @fields)["annotations"]
    end

    def parse(hash)
      @type = hash["type"]
      @entity = hash["entity"]
      @name = hash["name"]
      @text = hash["text"]
    end
  end

  class Area < Ressource
    include Request

    public

    attr_accessor :s_aid, :s_alias, :s_area, :s_begin, :s_comment, :s_end
    attr_accessor :s_ended, :s_iso, :s_iso1, :s_iso2, :s_iso3, :sortname
    attr_accessor :s_type
    attr_reader :id, :name, :sort_name, :iso_codes
    attr_reader :life_span, :aliases

    def self.search(data, linker = "AND")
      res = Request.get("area", data, linker)
      @results = res["areas"]
      return @results
    end

    def search()
      params = {}
      params[:aid] = @s_aid if !@s_aid.nil?
      params[:area] = @s_area if !@s_area.nil?
      params[:begin] = @s_begin if !@s_begin.nil?
      params[:comment] = @s_comment if !@s_comment.nil?
      params[:end] = @s_end if !@s_end.nil?
      params[:ended] = @s_ended if !@s_ended.nil?
      params[:iso] = @s_iso if !@s_iso.nil?
      params[:iso1] = @s_iso1 if !@s_iso1.nil?
      params[:iso2] = @s_iso2 if !@s_iso2.nil?
      params[:iso3] = @s_iso3 if !@s_iso3.nil?
      params[:sortname] = @s_sortname if !@s_sortname.nil?
      params[:type] = @s_type if !@s_type.nil?
      return Request.get("area", params)["areas"]
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
      if !hash["life-span"].nil?
        @life_span = LifeSpan.new(hash["life-span"])
      end
      @aliases = []
      if !hash["aliases"].nil?
        hash["aliases"].each do |h|
          @aliases.push(Alias.new(h))
        end
      end
    end
  end

  class Artist < Ressource
    include Request

    public

    attr_accessor :s_alias, :s_area, :s_arid, :s_artist, :s_artistaccent
    attr_accessor :s_begin, :s_beginarea, :s_comment, :s_end, :s_endarea
    attr_accessor :s_ended, :s_gender, :s_ipi, :s_sortname, :s_tag, :s_type
    attr_accessor :s_country

    attr_reader :id, :name, :sort_name, :aliases, :tags, :area, :begin_area
    attr_reader :type, :type_id, :life_span

    def self.search(data, linker = "AND")
      res = Request.get("artist", data, linker)
      @results = res["artists"]
      return @results
    end

    def search()
      params = {}
      params[:alias] = @s_alias if !@s_alias.nil?
      params[:area] = @s_area if !@s_area.nil?
      params[:arid] = @s_arid if !@s_arid.nil?
      params[:artist] = @s_artist if !@s_artist.nil?
      params[:artistaccent] = @s_artistaccent if !@s_artistaccent.nil?
      params[:begin] = @s_begin if !@s_begin.nil?
      params[:beginarea] = @s_beginarea if !@s_beginarea.nil?
      params[:comment] = @s_comment if !@s_comment.nil?
      params[:country] = @s_country if !@s_country.nil?
      params[:end] = @s_end if !@s_end.nil?
      params[:endarea] = @s_endarea if !@s_endarea.nil?
      params[:ended] = @s_ended if !@s_ended.nil?
      params[:gender] = @s_gender if !@s_gender.nil?
      params[:ipi] = @s_ipi if !@s_ipi.nil?
      params[:sortname] if !@s_sortname.nil?
      params[:tag] = @s_tag if !@s_tag.nil?
      params[:type] = @s_type if !@s_type.nil?
      return Request.get("artist", params)["artists"]
    end

    def parse(hash)
      @id = hash["id"]
      @name = hash["name"]
      @sort_name = hash["sort-name"]
      @type = hash["type"]
      @type_id = hash["type-id"]
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
      @tags = []
      if !hash["tags"].nil?
        hash["tags"].each do |h|
          @tags.push(Tag.new(h))
        end
      end
      if !hash["life-span"].nil?
        @life_span = LifeSpan.new(hash["life-span"])
      end
    end
  end

  class CDStub
    include Request

    public

    attr_accessor :s_artist, :s_barcode, :s_comment, :s_discid, :s_title
    attr_accessor :s_tracks

    attr_reader :id, :count, :title, :artist, :barcode, :disambiguation

    def self.search(data, linker = "AND")
      res = Request.get("cdstub", data, linker)
      @results = res["cdstubs"]
      return @results
    end

    def search()
      params = {}
      params[:artist] = @s_artist if !@s_artist.nil?
      params[:barcode] = @s_barcode if !@s_barcode.nil?
      params[:comment] = @s_comment if !@s_comment.nil?
      params[:s_discid] = @s_discid if !@s_discid.nil?
      params[:title] = @s_title if !@s_title.nil?
      params[:tracks] = @s_tracks if !@s_tracks.nil?
      return Request.get("cdstub", params)["cdstubs"]
    end

    def parse(hash)
      @id = hash["id"]
      @count = hash["count"].to_i
      @title = hash["title"]
      @artist = hash["artist"]
      @barcode = hash["barcode"]
    end
  end

  class Coordinates < Ressource
    public

    attr_reader :latitude, :longitude

    def parse(hash)
      @latitude = hash["latitude"].to_f
      @longitude = hash["longitude"].to_f
    end
  end

  class Event < Ressource
    include Request

    public

    attr_accessor :s_alias, :s_aid, :s_area, :s_arid, :s_artist, :s_comment
    attr_accessor :s_eid, :s_event, :s_pid, :s_place, :s_type, :s_tag
    attr_reader :id, :type, :name, :life_span, :time, :relations

    def search
      fields = {}
      fields[:alias] = @s_alias if !@s_alias.nil?
      fields[:area] = @s_area if !@s_area.nil?
      fields[:arid] = @s_arid if !@s_arid.nil?
      fields[:artist] = @s_artist if !@s_artist.nil?
      fields[:comment] = @s_comment if !@s_comment.nil?
      fields[:eid] = @s_eid if !@s_eid.nil?
      fields[:event] = @s_event if !@s_event.nil?
      fields[:pid] = @s_pid if !@s_pid.nil?
      fields[:place] = @s_place if !@s_place.nil?
      fields[:type] = @s_type if !@s_type.nil?
      fields[:tag] = @s_tag if !@s_tag.nil?
      return Request.get("event", fields)["events"]
    end

    def parse(hash)
      @id = hash["id"]
      @type = hash["type"]
      @name = hash["name"]
      @life_span = hash["life-span"]
      @relations = []
      if !hash["relations"].nil?
        hash["relations"].each do |h|
          @relations.push(Relation.new(h))
        end
      end
    end

    def self.search(data, linker = "AND")
      res = Request.get("event", data, linker)
      @results = res["events"]
      return @results
    end
  end

  class Instrument < Ressource
    include Request

    public

    attr_accessor :s_alias, :s_comment, :s_description, :s_iid, :s_instrument
    attr_accessor :s_type, :s_tag
    attr_reader :id, :type, :type_id, :name, :description, :aliases

    def search()
      fields = {}
      fields[:alias] = @s_alias if !@s_alias.nil?
      fields[:comment] = @s_comment if !@s_comment.nil?
      fields[:description] = @s_description if !@s_description.nil?
      fields[:iid] = @s_iid if !@s_iid.nil?
      fields[:instrument] = @s_instrument if !@s_instrument.nil?
      fields[:type] = @s_type if !@s_type.nil?
      fields[:tag] = @s_tag if !@s_tag.nil?
      return Request.get("instrument", fields)["instruments"]
    end

    def parse(hash)
      @id = hash["id"]
      @type = hash["type"]
      @type_id = hash["type_id"]
      @name = hash["name"]
      @description = hash["description"]
      @aliases = []
      if !hash["aliases"].nil?
        hash["aliases"].each do |h|
          @aliases.push(Alias.new(h))
        end
      end
    end

    def self.search(data, linker = "AND")
      res = Request.get("instrument", data, linker)
      @results = res["instruments"]
      return @results
    end
  end

  class LifeSpan < Ressource
    public

    attr_reader :begin, :ended

    def parse(hash)
      @begin = hash["begin"]
      @ended = hash["ended"]
    end
  end

  class Label
    include Request

    public

    attr_accessor :s_alias, :s_area, :s_begin, :s_code, :s_comment, :s_country
    attr_accessor :s_end, :s_ended, :s_ipi, :s_label, :s_labelaccent, :s_laid
    attr_accessor :s_sortname, :s_type, :s_tag

    attr_reader :id, :type, :type_id, :name, :sort_name, :country, :area
    attr_reader :life_span, :aliases

    def search()
      fields = {}
      fields[:alias] = @s_alias if !@s_alias.nil?
      fields[:area] = @s_area if !@s_area.nil?
      fields[:begin] = @s_begin if !@s_begin.nil?
      fields[:code] = @s_code if !@s_code.nil?
      fields[:comment] = @s_comment if !@s_comment.nil?
      fields[:country] = @s_country if !@s_country.nil?
      fields[:end] = @s_end if !@s_end.nil?
      fields[:ended] = @s_ended if !@s_ended.nil?
      fields[:ipi] = @s_ipi if !@s_ipi.nil?
      fields[:label] = @s_label if !@s_label.nil?
      fields[:labelaccent] = @s_labelaccent if !@s_labelaccent.nil?
      fields[:laid] = @s_laid if !@s_laid.nil?
      fields[:sortname] = @s_sortname if !@s_sortname.nil?
      fields[:type] = @s_type if !@s_type.nil?
      fields[:tag] = @s_tag if !@s_tag.nil?
      return Request.get("label", fields)["labels"]
    end

    def parse(hash)
      @id = hash["id"]
      @type = hash["type"]
      @type_id = hash["type_id"]
      @name = hash["name"]
      @sort_name = hash["sort_name"]
      @country = hash["country"]
      @area = Area.new(hash["area"])
      @life_span = LifeSpan.new(hash["life_sapn"])
      @aliases = []
      if !hash["aliases"].nil?
        hash["aliases"].each do |h|
          @aliases.push(Alias.new(h))
        end
      end
    end

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

    attr_accessor :s_pid, :s_address, :s_alias, :s_area, :s_begin, :s_comment
    attr_accessor :s_end, :s_ended, :s_lat, :s_long, :s_place, :s_placeaccent
    attr_accessor :s_type

    attr_reader :id, :type, :type_id, :name, :address, :coordinates, :area
    attr_reader :life_span

    def search()
      fields = {}
      fields[:pid] = @s_pid if !@s_pid.nil?
      fields[:alias] = @s_address if !@s_address.nil?
      fields[:area] = @s_area if !@s_area.nil?
      fields[:begin] = @s_begin if !@s_begin.nil?
      fields[:comment] = @s_comment if !@s_comment.nil?
      fields[:end] = @s_end if !@s_end.nil?
      fields[:ended] = @s_ended if !@s_ended.nil?
      fields[:lat] = @s_lat if !@s_lat.nil?
      fields[:long] = @s_long if !@s_long.nil?
      fields[:place] = @s_place if !@s_place.nil?
      fields[:placeaccent] = @s_placeaccent if !@s_placeaccent.nil?
      fields[:type] = @s_type if !@s_type.nil?
      return Request.get("place", fields)["places"]
    end

    def parse(hash)
      @id = hash["id"]
      @type = hash["type"]
      @name = hash["name"]
      @address = hash["address"]
      @coordinates = Coordinates.new(hash["coordinates"])
      @area = Area.new(hash["area"])
      @life_span = LifeSpan.new(hash["life-span"])
    end

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

    attr_accessor :s_arid, :s_artist, :s_artistname, :s_creditname, :s_comment
    attr_accessor :s_country, :s_date, :s_dur, :s_format, :s_isrc, :s_number
    attr_accessor :s_position, :s_primarytype, :s_qdur, :s_recording
    attr_accessor :s_recordingaccent, :s_reid, :s_release, :s_rgid, :s_rid
    attr_accessor :s_secondarytype, :s_status, :s_tid, :s_tnum, :s_tracks
    attr_accessor :s_tracksrelease, :s_tag, :s_type, :s_video

    attr_reader :id, :artist, :artists, :title, :duration, :releases, :video

    def self.search(data, linker = "AND")
      res = Request.get("recording", data, linker)
      return res["recordings"]
    end

    def search()
      fields = {}
      fields[:arid] = @s_arid if !@s_arid.nil?
      fields[:artist] = @s_artist if !@s_artist.nil?
      fields[:artistname] = @s_artistname if !@s_artistname.nil?
      fields[:creditname] = @s_creditname if !@s_creditname.nil?
      fields[:comment] = @s_comment if !@s_comment.nil?
      fields[:country] = @s_country if !@s_country.nil?
      fields[:date] = @s_date if !@s_date.nil?
      fields[:dur] = @s_dur if !@s_dur.nil?
      fields[:format] = @s_format if !@s_format.nil?
      fields[:isrc] = @s_isrc if !@s_isrc.nil?
      fields[:number] = @s_number if !@s_number.nil?
      fields[:position] = @s_position if !@s_position.nil?
      fields[:primarytype] = @s_primarytype if !@s_primarytype.nil?
      fields[:qdur] = @s_qdur if !@s_qdur.nil?
      fields[:recording] = @s_recording if !@s_recording.nil?
      fields[:recordingsaccent] = @s_recordingaccent if !@s_recordingaccent.nil?
      fields[:reid] = @s_reid if !@s_reid.nil?
      fields[:release] = @s_release if !@s_release.nil?
      fields[:rgid] = @s_rgid if !@rgid.nil?
      fields[:rid] = @s_rid if !@s_rid.nil?
      fields[:secondarytype] = @s_secondarytype if !@s_secondarytype.nil?
      fields[:status] = @s_status if !@s_status.nil?
      fields[:tid] = @s_tid if !@s_tid.nil?
      fields[:tnum] = @s_tnum if !@s_tnum.nil?
      fields[:tracks] = @s_tracks if !@s_tracks.nil?
      fields[:tracksrelease] = @s_tracksrelease if !@s_tracksrelease.nil?
      fields[:tag] = @s_tag if !@s_tag.nil?
      fields[:type] = @s_type if !@s_type.nil?
      fields[:video] = @s_type if !@s_video.nil?
      return Request.get("recording", fields)["recordings"]
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

    attr_accessor :s_arid, :s_artist, :s_artistname, :s_comment, :s_creditname
    attr_accessor :s_primarytype, :s_rgid, :s_releasegroup
    attr_accessor :s_releasegroupaccent, :s_releases, :s_release, :s_reid
    attr_accessor :s_secondarytype, :s_status, :s_tag, :s_type
    attr_reader :id, :type_id, :title, :primary_type, :artists, :releases

    def search()
      fields = {}
      fields[:arid] = @s_arid if !@s_arid.nil?
      fields[:artist] = @s_artist if !@s_artist.nil?
      fields[:artistname] = @s_artistname if !@s_artistname.nil?
      fields[:comment] = @s_comment if !@s_comment.nil?
      fields[:creditname] = @s_creditname if !@s_creditname.nil?
      fields[:primarytype] = @s_primarytype if !@s_primarytype.nil?
      fields[:rgid] = @s_rgid if !@s_rgid.nil?
      fields[:releasegroup] = @s_releasegroup if !@s_releasegroup.nil?
      fields[:releasegroupaccent] =
        @s_releasegroupaccent if !@s_releasegroupaccent.nil?
      fields[:releases] = @s_releases if !@s_releases.nil?
      fields[:release] = @s_release if !@s_release.nil?
      return Request.get("release-group", fields)["release-groups"]
    end

    def parse(hash)
      @id = hash["id"]
      @type_id = hash["type-id"]
      @title = hash["title"]
      @primary_type = hash["primary-type"]
      @artists = []
      if !hash["artist-credit"].nil?
        hash["artist-credit"].each do |ha|
          @artists.push(Artist.new(ha["artist"]))
        end
      end
      @releases = []
      if !hash["releases"].nil?
        hash["releases"].each do |h|
          @releases.push(Release.new(h))
        end
      end
    end

    def self.search(data, linker = "AND")
      res = Request.get("release-group", data, linker)
      @results = res["release-groups"]
      return @results
    end
  end

  class Relation < Ressource
    public

    attr_reader :type, :type_id, :direction, :artist, :release

    def parse(hash)
      @type = hash["type"]
      @type_id = hash["type-id"]
      @direction = hash["direction"]
      @artist = Artist.new(hash["artist"]) if !hash["artist"].nil?
      @release = Release.new(hash["release"]) if !hash["release"].nil?
    end
  end

  class Release < Ressource
    include Request

    public

    attr_accessor :s_arid, :s_artist, :s_artistname, :s_asin, :s_barcode
    attr_accessor :s_catno, :s_comment, :s_country, :s_creditname, :s_date
    attr_accessor :s_discids, :s_discidsmedium, :s_format, :s_laid, :s_label
    attr_accessor :s_lang, :s_mediums, :s_primarytype, :s_puid, :s_quality
    attr_accessor :s_reid, :s_release, :s_releaseaccent, :s_rgid, :s_script
    attr_accessor :s_secondarytype, :s_status, :s_tag, :s_tracks
    attr_accessor :s_tracksmedium, :s_type

    attr_reader :id, :title, :artist, :release_group, :track_count, :media
    attr_reader :date, :country, :release_events, :text_representation

    def search()
      @fields[:arid] = @s_arid if !@s_arid.nil?
      @fields[:artist] = @s_artist if !@s_artist.nil?
      @fields[:asin] = @s_asin if !@s_asin.nil?
      @fields[:barcode] = @s_barcode if !@s_barcode.nil?
      @fields[:catno] = @s_catno if !@s_catno.nil?
      @fields[:comment] = @s_comment if !@s_comment.nil?
      @fields[:country] = @s_country if !@s_comment.nil?
      @fields[:creditname] = @s_date if !@s_date.nil?
      @fields[:date] = @s_date if !@s_date.nil?
      @fields[:discids] = @s_discids if !@s_discids.nil?
      @fields[:discidsmedium] = @s_discidsmedium if !@s_discidsmedium.nil?
      @fields[:format] = @s_format if !@s_format.nil?
      @fields[:laid] = @s_laid if !@s_laid.nil?
      @fields[:label] = @s_label if !@s_label.nil?
      @fields[:lang] = @s_lang if !@s_lang.nil?
      @fields[:mediums] = @s_mediums if !@s_mediums.nil?
      @fields[:primarytype] = @s_primarytype if !@s_primarytype.nil?
      @fields[:puid] = @s_puid if !@s_puid.nil?
      @fields[:quality] = @s_quality if !@s_quality.nil?
      @fields[:reid] = @s_release if !@s_release.nil?
      @fields[:release] = @s_release if !@s_release.nil?
      @fields[:releaseaccent] = @s_releaseaccent if !@s_releaseaccent.nil?
      @fields[:rgid] = @s_rgid if !@s_rgid.nil?
      @fields[:script] = @s_script if !@s_script.nil?
      @fields[:secondarytype] = @s_secondarytype if !@s_secondarytype.nil?
      @fields[:status] = @s_status if !@s_status.nil?
      @fields[:tag] = @s_tag if !@s_tag.nil?
      @fields[:tracks] = @s_tags if !@s_tags.nil?
      @fields[:tracksmedium] = @s_tracksmedium if !@s_tracksmedium.nil?
      @fields[:type] = @s_type if !@s_type.nil?
      return Request.get("release", @fields)["releases"]
    end

    def parse(hash)
      @id = hash["id"]
      @title = hash["title"]
      @track_count = hash["track-count"]
      @date = hash["date"]
      @country = hash["country"]
      @status = hash["status"]
      @packaging = hash["packaging"]
      if !hash["text-representation"].nil?
        @text_representation = TextRepresentation.new(hash["text-representation"])
      end
      @artist = []
      if !hash["artist-credit"].nil?
        hash["artist-credit"].each do |h|
          @artist.push(Artist.new(h))
        end
      end
      if !hash["release-group"].nil?
        @release_group = ReleaseGroup.new(hash["release-group"])
      end
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

    def self.search(data, linker = "AND")
      res = Request.get("release", data, linker)
      @results = res["releases"]
      return @results
    end
  end

  class Series < Ressource
    include Request

    public

    attr_accessor :s_alias, :s_comment, :s_series, :s_sid, :s_type, :s_tag

    attr_reader :id, :type, :type_id, :name, :disambiguation, :tags

    def search()
      @fields[:alias] = @s_alias if !@s_alias.nil?
      @fields[:comment] = @s_comment if !@s_comment.nil?
      @fields[:series] = @s_series if !@s_series.nil?
      @fields[:sid] = @s_sid if !@s_sid.nil?
      @fields[:type] = @s_type if !@s_type.nil?
      @fields[:tag] = @s_tag if !@s_tags.nil?
      return Request.get("series", @fields)["series"]
    end

    def parse(hash)
      @id = hash["id"]
      @type = hash["type"]
      @type_id = hash["type-id"]
      @name = hash["name"]
      @disambiguation = hash["disambiguation"]
      @tags = []
      if !hash["tags"].nil?
        hash["tags"].each do |h|
          @tags.push(Tag.new(h))
        end
      end
    end

    def self.search(data, linker = "AND")
      res = Request.get("series", data, linker)
      @results = res["series"]
      return @results
    end
  end

  class Tag < Ressource
    include Request

    public

    attr_accessor :s_tag
    attr_reader :count, :name

    def search()
      @fields[:tag] = @s_tag if !@s_tag.nil?
      res = Request.get("tag", @fields)
      return res["tags"]
    end

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

  class TextRepresentation < Ressource
    public

    attr_reader :language, :script

    def parse(hash)
      @language = hash["language"]
      @script = hash["script"]
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

    attr_accessor :s_relationtype, :s_targetid, :s_targettype, :s_uid, :s_url

    attr_reader :id, :resource, :relations

    def search()
      fields = {}
      fields[:relationtype] = @s_relationtype if !@relationtype.nil?
      fields[:s_targetid] = @s_targetid if !@s_targetid.nil?
      fields[:s_uid] = @s_uid if !@s_uid.nil?
      fields[:s_url] = @s_url if !@s_url.nil?
      return Request.get("url", fields)["urls"]
    end

    def parse(hash)
      @id = hash["id"]
      @resource = hash["resource"]
      @relations = []
      if !hash["relation-list"].nil?
        hash["relation-list"].each do |ha|
          ha["relations"].each do |h|
            @relations.push(Relation.new(h))
          end
        end
      end
    end

    def self.search(data, linker = "AND")
      res = Request.get("url", data, linker)
      @results = res["urls"]
      return @results
    end
  end

  class Work < Ressource
    include Request

    public

    attr_accessor :s_alias, :s_arid, :s_artist, :s_comment, :s_iswc, :s_lang
    attr_accessor :s_tag, :s_type, :s_wid, :s_work, :s_workaccent
    attr_reader :id, :title, :relations, :languages

    def search()
      @fields[:alias] = @s_alias if !@s_alias.nil?
      @fields[:arid] = @s_arid if !@s_arid.nil?
      @fields[:artist] = @s_comment if !@s_comment.nil?
      @fields[:iswc] = @s_iswc if !@s_iswc.nil?
      @fields[:lang] = @s_lang if !@s_lang.nil?
      @fields[:tag] = @s_tag if !@s_tag.nil?
      @fields[:type] = @s_type if !@s_type.nil?
      @fields[:wid] = @s_wid if !@s_wid.nil?
      @fields[:work] = @s_work if !@s_work.nil?
      @fields[:workaccent] = @s_workaccent if !@s_workaccent.nil?
      return Request.get("work", @fields)["works"]
    end

    def parse(hash)
      @id = hash["id"]
      @title = hash["title"]
      @relations = []
      if !hash["relations"].nil?
        hash["relations"].each do |h|
          @relations.push(Relation.new(h))
        end
      end
      @languages = []
      if !hash["languages"].nil?
        hash["languages"].each do |h|
          @languages.push(h)
        end
      end
    end

    def self.search(data, linker = "AND")
      res = Request.get("work", data, linker)
      @results = res["works"]
      return @results
    end
  end
end
