# musicbrainz2
Modern, minimal Ruby 2.X library (gem) to get data from MusicBrainz Web-API

## Features
* Ruby Standard Library only (no gems required)
* Will include nearly all searchable requests
* All ressources are parsed as Ruby classes
    * Could be get also as JSON or Ruby Hash

## Done
* Connect to MusicBrainz via application information
* Lookup for ressource ID with inc= subqueries
* Search by Apache Lucene (queries)[https://lucene.apache.org/core/4\_3\_0/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#package\_description] and by all possible search fields
* Browse ressources via other ressource IDs

## TODO
* Get more than 100 results with one method call
* Browse requests
* Open connection via MusicBrainz account

## Information
Additional information to MusicBrainz Web-API:
* (Global information)[https://musicbrainz.org/doc/Development/XML\_Web\_Service/Version\_2]
* (Searchable entities)[https://musicbrainz.org/doc/MusicBrainz\_Entity]
* (About web search)[https://musicbrainz.org/doc/Development/XML\_Web\_Service/Version\_2/Search]

## Examples
### Connection
As first step you need a new connection to 
```ruby
require "musicbrainz2"
include MusicBrainz2

# by application
Connection.new do |c|
  c.app = "Test app"
  c.version = "0.1"
  c.contact = "test@test.com"
end

# Connection.new("Test app", "0.1", "test@test.com") is also possible

# by account data (coming soon)
```

### Search by fields
Get entities by query or search-fields
```ruby
art = Artist.new
art.s_artist = "Amaranthe"

data = art.search

# some data
res = data.results.first
puts res.id
puts res.name
puts res.area.name
```

### Search by query
```ruby
data = Artist.query("Amon Amarth", 100)

# number of maximum query results and date of request
puts data.count.to_s + " " + data.created

# number of stored query results (default 25)
puts data.results.length

res = data.results.first
puts res.id
puts res.name
puts res.area.name
```

### Lookup
Get entity by id
```ruby
art = Artist.from_id("4bb4e4e4-5f66-4509-98af-62dbb90c45c5")
puts art.name
puts art.area.name
```

### Browse
Get entities by related ressource id
```ruby
# coming soon
```

### Raw Data
```ruby
hash = Artist.get_hash("Nightwish")
puts hash

json = Artist.get_json("Sabaton")
puts json
```

## Disclaimer
In which terms you allowed to use this library see (here)[https://musicbrainz.org/doc/Live\_Data\_Feed]

## License
(MIT)[https://choosealicense.com/licenses/mit/]

# Documentation
Coming soon
## Namespace
MusicBrainz2

## Connection
Class with static member that provides connection via application data or (later) via
account data 
## Request
Mixin (interface) with http requests for searchable core ressources
## Result
Wrapper class to get results parsed as Ruby classes and additional request
information

## Ressource
Abstract base class of all searchable and non-searchable ressources

### Core-Entities
Searchable ressources
#### Annotation
#### Area
#### Artist
#### CDStub
#### Event
#### Instrument
#### Label
#### Place
#### Recording
#### ReleaseGroup
#### Release
#### Series
#### Tag
#### URL
#### Work

### Further entities
#### Coordinates
#### LifeSpan
#### Media
#### Relation
#### ReleaseEvent
#### Series
#### TextRepresentation
#### Track
