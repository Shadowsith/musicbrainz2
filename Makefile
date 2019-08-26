all:
	gem build ./musicbrainz2.gemspec
	gem install ./musicbrainz2-0.1.0.gem
	ruby ./test.rb
