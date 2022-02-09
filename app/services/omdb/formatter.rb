module Omdb
    class Formatter
      class << self
        def by_id(input)
          raise StandardError.new('Please pass an id as param') unless input.key?(:id)
          {
            i: input[:id].strip
          }
        end
  
        def by_multiple_search(input)
          {
            s: input[:title].strip,
            type: input[:type]&.strip,
            y: input[:year]&.strip,
            page: input[:page]&.strip,
          }
        end
  
        def multiple_search_output(output)
          output.deep_transform_keys!(&:downcase)
          return {error: output[:error]} if output.key?(:error)
          {movies: output[:search].map { |movie| prettify_movies(movie) }, totalResult: output[:totalresults]}
        end
  
        def prettify_movies(output)
          output.transform_keys!(&:downcase)
          return {error: output[:error]} if output.key?(:error)
          {
            movie: {
            id: output[:imdbid],
            title: output[:title],
            year: output[:year],
            type: output[:type],
            poster: output[:poster]
            }.compact
          }
        end
  
        def prettify_movie_details(output)
          output.transform_keys!(&:downcase)
          return {error: output[:error]} if output.key?(:error)
          {
            movie: {
            id: output[:imdbid],
            title: output[:title],
            genre: output[:genre],
            year: output[:year],
            director: output[:director],
            runtime: output[:runtime],
            writers: output[:writers],
            actors: output[:actors],
            plot: output[:plot],
            poster: output[:poster],
            language: output[:language],
            imdbrating: output[:imdbrating],
            type: output[:type]
            }.compact
          }
        end
      end
    end
  end
  