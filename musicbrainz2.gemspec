Gem::Specification.new do |gem|
  gem.authors = ["Philip Mayer"]
  gem.email = ["philip.mayer@shadowsith.de"]
  gem.homepage = "https://github.com/Shadowsith/musicbrainz2"
  gem.name = "musicbrainz2"
  gem.version = "0.1.0"
  gem.date = "2019-08-26"
  gem.summary = "A Ruby 2.x MusicBrainz Web Service wrapper"
  gem.files = [
    "lib/musicbrainz2.rb",
    "lib/musicbrainz2/connection.rb",
    "lib/musicbrainz2/request.rb",
    "lib/musicbrainz2/result.rb",
    "lib/musicbrainz2/ressources.rb",
  ]
  gem.license = "MIT"
end
