module SimpBot
  module Facts
    class Api
      API_URL = "https://uselessfacts.jsph.pl/random.json"

      def random_fact
        HTTParty.get(API_URL).parsed_response
      end
    end
  end
end