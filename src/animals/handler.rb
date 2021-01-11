require_relative "../handler"

module SimpBot
  module Animals
    class MessageHandler < MessageHandlerBase

      def handle_message(event)
        words = event.message.content.split " "

        endpoint = Animals::ENDPOINTS.find { |endpoint|
          endpoint[:commands].include? words[0]
        }

        unless endpoint.nil?

          count = parse_count(words[1])

          count.times do 
            response = HTTParty.get(endpoint[:url], headers: endpoint[:headers] || {}).parsed_response
            image = endpoint[:extract].call(response)

            embed = Discordrb::Webhooks::Embed.new

            embed.title = endpoint[:title]
            embed.timestamp = event.timestamp
            embed.footer = Discordrb::Webhooks::EmbedFooter.new text: event.message.user.username,
                                                                icon_url: event.message.user.avatar_url

            if %w[.mp4 .webm].any? do |format|
              image.end_with? format
            end
              embed.description = image
            else
              embed.image = Discordrb::Webhooks::EmbedImage.new url: image
            end

            event.channel.send_message(nil, nil, embed)
          end
        end
      end

      private 

      def parse_count(source)
        if source.nil? || !source.match(/^\d$/)
          return 1
        end

        [1, source.to_i].max
      end
    end
  end
end
