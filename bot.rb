require 'discordrb'
require_relative 'src/setup'

module Astronomia
  bot = Discordrb::Bot.new token: ENV["DISCORD_TOKEN"], ignore_bots: true
  api = Api.new

  bot.message do |event|
    content = event.message.content

    if content.start_with? "+horoscope"
      arguments = content.split(" ").drop(1)

      raise Errors::InvalidArgumentError if arguments.length > 2

      begin
        # +horoscope -- for users with registered zodiac sign
        if arguments.empty?
          horoscope = api.horoscope_for_user event.author.id

        # +horoscope register
        elsif arguments[0] == "register"
          raise Errors::InvalidZodiacSignError unless Horoscope.is_valid_zodiac? arguments[1]

          horoscope = api.register_user event.author.id, arguments[1]

        # +horoscope aries
        elsif arguments.length == 1
          raise Errors::InvalidZodiacSignError unless Horoscope.is_valid_zodiac? arguments[0]

          horoscope = api.horoscope_for_zodiac_sign arguments[0]

        # Invalid usage
        else
          raise Errors::InvalidArgumentError
        end

        embed = horoscope.to_embed api
        embed.footer = Discordrb::Webhooks::EmbedFooter.new text: event.message.user.username,
                                                            icon_url: event.message.user.avatar_url

        event.channel.send_message(nil, nil, embed)

      rescue StandardError => error
        embed = Discordrb::Webhooks::Embed.new title: "Ah snap!",
                                               description: error.message,
                                               color: "#ff6b6b"

        embed.add_field name: "Error type", value: "`#{error.class.to_s}`"
        event.channel.send_message(nil, nil, embed)
      end
    end
  end

  bot.run
end