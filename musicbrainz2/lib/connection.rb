module MusicBrainz2
  class Connection
    private

    @@agent = ""
    @@version = ""
    @@contact = ""

    public

    def initialize(agent_name = "", agent_version = "", agent_contact = "")
      @@agent = agent_name
      @@version = agent_version
      @@contact = agent_contact
    end

    def self.agent=(val)
      @@agent = val
    end

    def self.agent
      return @@agent
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
