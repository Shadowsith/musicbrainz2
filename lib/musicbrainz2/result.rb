module MusicBrainz2
  class Result
    private

    def getInformation
      if @count.nil?
        @count = hash["artist-count"]
      end
      if @offset.nil?
        @offset = hash["artist-offset"]
      end
    end

    protected

    attr_writer :results, :count, :created

    public

    attr_reader :results, :count, :created

    def initialize(hash, res_name, type = nil)
      @count = hash["count"]
      @created = hash["created"]
      @offset = hash["offset"]
      @results = hash[res_name] if !res_name.nil?

      # generic parsing results
      if !@results.nil? && type < Ressource
        parse(type)
      end
    end

    def parse(type)
      @results.collect! do |r|
        r = type.new(r)
      end
    end
  end
end
