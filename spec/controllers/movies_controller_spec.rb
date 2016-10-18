require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
  it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
    it 'should notify on an invalid search term entry' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => ''}
      expect(flash[:notice]).to eq("Invalid search terms")
    end
    it 'should notify if no matches are found' do
      fake_results = []
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'eqwew'}
      expect(flash[:notice]).to eq("No matching movies were found on TMDb")
    end
    
  describe 'add_tmdb'
    it 'should call the model method that performs TMDb add' do
      movies = {double('movie1') => 1}
      expect(Movie).to receive(:create_from_tmdb).once
      post :add_tmdb, {:tmdb_movies => movies}
    end
    it 'should call the model method that performs TMDb add for more than one selection' do
      movies = {double('movie1') => 1, double('movie2') => 1}
      expect(Movie).to receive(:create_from_tmdb).twice
      post :add_tmdb, {:tmdb_movies => movies}
    end
    it 'should notify when movies are successfully added' do
      movies = {double('movie1') => 1}
      allow(Movie).to receive(:create_from_tmdb).once
      post :add_tmdb, {:tmdb_movies => movies}
      expect(flash[:notice]).to eq("Movies successfully added to Rotten Potatoes")
    end 
    it 'should notify user when no movies are selected' do
      allow(Movie).to receive(:create_from_tmdb)
      post :add_tmdb, {:tmdb_movies => nil}
      expect(flash[:notice]).to eq("No movies selected")
    end
  end
end