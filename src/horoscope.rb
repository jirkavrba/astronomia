module Astronomia
  class Horoscope < Struct.new(
      :zodiac_sign,
      :emoji,
      :sex,
      :hustle,
      :vibe,
      :success,
      :love,
      :friendship,
      :career
  )

    ZODIAC_SIGNS = [
        :aries,
        :taurus,
        :gemini,
        :cancer,
        :leo,
        :virgo,
        :libra,
        :scorpio,
        :sagittarius,
        :capricorn,
        :aquarius,
        :pisces
    ]

    def self.is_valid_zodiac? sign
      ZODIAC_SIGNS.include? sign.to_sym
    end

    def to_embed api
      image = Discordrb::Webhooks::EmbedThumbnail.new url: "https://www.horoscope.com/images-US/signs/#{zodiac_sign}.png"
      embed = Discordrb::Webhooks::Embed.new title: zodiac_sign.capitalize,
                                             thumbnail: image,
                                             color: "#4ecdc4"

      embed.add_field name: stars(sex[:stars]) + " | Sex", value: sex[:text]
      embed.add_field name: stars(hustle[:stars]) + " | Hustle", value: hustle[:text]
      embed.add_field name: stars(vibe[:stars]) + " | Vibe", value: vibe[:text]
      embed.add_field name: stars(success[:stars]) + " | Success", value: success[:text]

      embed.add_field name: "Love: " + love, value: matches(api, love)
      embed.add_field name: "Friendship: " + friendship, value: matches(api, friendship)
      embed.add_field name: "Career: " + career, value: matches(api, career)

      p embed

      embed
    end

    private

    def stars count
      "★" * count +
      "☆" * (5 - count)
    end

    def matches api, zodiac_sign
      matches = api.matches_for_zodiac_sign zodiac_sign.downcase

      if matches.empty?
        'No matches'
      else
        matches.map do |id| "<@#{id}>" end .join(", ")
      end
    end
  end
end