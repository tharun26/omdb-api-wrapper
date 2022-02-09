require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
  def setup
    api_key = ENV['OMDB_API_KEY']
    omdb_mock = json_response('omdb_response')
    request_stubber([
      {
        url: "https://www.omdbapi.com/?apikey=#{api_key}&i=t000000022",
        http_status: 200,
        body: {"Response": 'False', "Error": 'Incorrect IMDb ID.'}.to_json
      },
      {
        url: "https://www.omdbapi.com/?apikey=#{api_key}&i=tt1130884",
        http_status: 200,
        body: omdb_mock
      },
      {
        url: "https://www.omdbapi.com/?apikey=#{api_key}&t=Shutter%20Island&type",
        http_status: 200,
        body: omdb_mock
      },
      {
        url: "https://www.omdbapi.com/?apikey=#{api_key}&s=Island&type&y",
        hhtp_status: 200,
        body: json_response('omdb_multiple_search_response')
      }])
  end

  test '#search_by_id return json with a specific movie query on OMDB by id' do
    get api_v1_movie_path('tt1130884')
    assert_response :success
    assert_equal({'movie'=>{"id"=> 'tt1130884',
        "title"=> 'Shutter Island',
        "genre"=> 'Mystery, Thriller',
        "year"=> '2010',
        "director"=> 'Martin Scorsese',
        "type"=> 'movie',
        "runtime"=> '138 min', 
        "actors"=> "Leonardo DiCaprio, Mark Ruffalo, Ben Kingsley, Max von Sydow", 
        "plot"=> "In 1954, a U.S. Marshal investigates the disappearance of a murderer who escaped from a hospital for the criminally insane.", 
        "poster"=> "https://m.media-amazon.com/images/M/MV5BYzhiNDkyNzktNTZmYS00ZTBkLTk2MDAtM2U0YjU1MzgxZjgzXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg", 
        "language"=> 'English, German', 
        "imdbrating"=> "8.2", 
        "type"=> "movie"}}, JSON.parse(response.body))
  end

  test '#multiple_search return json with a movies with a similar title' do
    get api_v1_search_path, params: {title: 'Island'}
    assert_response :success
    assert_equal({"movies"=>[{"movie"=>{"id"=>"tt1130884", "title"=>"Shutter Island", "year"=>"2010", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BYzhiNDkyNzktNTZmYS00ZTBkLTk2MDAtM2U0YjU1MzgxZjgzXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg"}}, {"movie"=>{"id"=>"tt0399201", "title"=>"The Island", "year"=>"2005", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BMTAwNjk0NjM1ODReQTJeQWpwZ15BbWU3MDc1NjIxMzM@._V1_SX300.jpg"}}, {"movie"=>{"id"=>"tt3731562", "title"=>"Kong: Skull Island", "year"=>"2017", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BZDg0OGM1NWEtNDEwOC00OTE2LTliZWEtNzg1MTZkNjFlMmNhXkEyXkFqcGdeQXVyMTA4NjE0NjEy._V1_SX300.jpg"}}, {"movie"=>{"id"=>"tt1397514", "title"=>"Journey 2: The Mysterious Island", "year"=>"2012", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BMjA5MTE1MjQyNV5BMl5BanBnXkFtZTcwODI4NDMwNw@@._V1_SX300.jpg"}}, {"movie"=>{"id"=>"tt0287717", "title"=>"Spy Kids 2: Island of Lost Dreams", "year"=>"2002", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BNWM2N2JjYzYtYWIyNS00NDc3LWFkNDctMmYwOWQyZTcxYjZhXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"}}, {"movie"=>{"id"=>"tt9686708", "title"=>"The King of Staten Island", "year"=>"2020", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BYzkxMzMzOTgtNmZhMS00MGM0LTk3MzUtMjE1MzI4MzU5ZjkzXkEyXkFqcGdeQXVyMDA4NzMyOA@@._V1_SX300.jpg"}}, {"movie"=>{"id"=>"tt0983946", "title"=>"Fantasy Island", "year"=>"2020", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BOWE2ODZhYWYtNTFiYy00MjdmLWIzZGEtNTkyOTc1NDIwMjk4XkEyXkFqcGdeQXVyMzY0MTE3NzU@._V1_SX300.jpg"}}, {"movie"=>{"id"=>"tt0410377", "title"=>"Nim's Island", "year"=>"2008", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BMTA0OTk0NjIwMDleQTJeQWpwZ15BbWU3MDg3NjM0NTE@._V1_SX300.jpg"}}, {"movie"=>{"id"=>"tt0116654", "title"=>"The Island of Dr. Moreau", "year"=>"1996", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BYjQxNmM5ODItMGM3Yi00N2VlLTkwNTEtNDZkNzUyYzA3MmIxXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"}}, {"movie"=>{"id"=>"tt1174730", "title"=>"City Island", "year"=>"2009", "type"=>"movie", "poster"=>"https://m.media-amazon.com/images/M/MV5BMTM1MTY2Mjk0Nl5BMl5BanBnXkFtZTcwMDYxODkxMw@@._V1_SX300.jpg"}}], "totalResult"=>"2388"}, JSON.parse(response.body))
  end
end
