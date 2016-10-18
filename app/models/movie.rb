class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  def self.find_in_tmdb(string)
    begin
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      movies = Array.new
      Tmdb::Movie.find(string).each do |a|
        movies << {:tmdb_id => a.id, :title => a.title, :rating => self.get_rating(a.id), :release_date => a.release_date}
      end
      movies
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.get_rating(tmbd_id)
    movies = Tmdb::Movie.releases(tmbd_id)['countries']
    movies.each do |movie|
      if (movie["iso_3166_1"] == "US" && !movie["certification"].blank?)
        return movie['certification']
      else
        return "NR"
      end  
    end
  end
  
end
