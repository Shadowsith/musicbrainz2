module MusicBrainz2
  class Connection
    private

    @@app = ""
    @@version = ""
    @@contact = ""

    public

    def initialize(agent_name = "", agent_version = "", agent_contact = "")
      @@app = agent_name
      @@version = agent_version
      @@contact = agent_contact
    end

    def self.app=(val)
      @@app = val
    end

    def self.app
      return @@app
    end

    def self.version=(val)
      @@version = val
    end

    def self.version
      return @@version
    end

    def self.contact=(val)
      @@contact = val
    end

    def self.contact
      return @@contact
    end
  end
end
