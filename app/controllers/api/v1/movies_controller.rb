module Api
  module V1
    class MoviesController < ApplicationController
      def search_by_id
        response, status = Omdb::Handler.by_id(permitted_params_search_by_id)
        json_response(response, status)
      end
  
      def multiple_search
        response, status = Omdb::Handler.multiple_search(permitted_params_multiple_search)
        json_response(response, status)
      end

      private
        def permitted_params_search_by_id
          params.permit(:id)
        end

        def permitted_params_multiple_search
          params.permit(:title, :type, :year, :page)
        end
    end
  end
end
