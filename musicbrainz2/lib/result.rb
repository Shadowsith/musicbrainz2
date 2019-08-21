module MusicBrainz2
  class Result
    protected

    attr_writer :results, :count, :created

    public

    attr_reader :results, :count, :created

    def initialize(hash, res_name, type)
      @count = hash["count"]
      @created = hash["created"]
      @results = hash[res_name] if @res_name.nil?
    end

    def parse(type)
      @results.each do |r|
        r = type.new(r)
      end
    end
  end
end
