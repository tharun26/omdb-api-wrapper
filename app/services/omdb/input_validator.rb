module Omdb
    class InputValidator
      class InputException < StandardError; end
      attr_accessor :input
  
      def initialize(input = {})
        @input = input
      end
  
      def validate_id
        return input if input.key?(:id)
  
        raise InputException.new('Need to provide id as param')
      end
  
      def validate_multiple_search
        return input if input.key?(:title)
        raise InputException.new('Need to provide title as param for multiple searching')
      end
    end
  end
  