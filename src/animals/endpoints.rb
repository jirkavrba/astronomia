module SimpBot
  module Animals
    ENDPOINTS = [
      {
        commands: %w[+cat +catto +pussy],
        url: "https://api.thecatapi.com/v1/images/search",
        headers: {
          "x-api-key" => ENV.fetch("CATS_API_KEY") {
                           raise Animals::Errors::ApiTokenNotSetup.new "CATS_API_KEY"
                         }
        },
        title: "Meow!",
        extract: ->(json) { json[0]["url"] }
      },
      {
        commands: %w[+dog +doggo],
        url: "https://random.dog/woof.json",
        title: "Woof!",
        extract: ->(json) { json["url"] }
      },
      {
        commands: %w[+fox +foxxo],
        url: "https://randomfox.ca/floof/",
        title: "What does the fox say?",
        extract: ->(json) { json["image"] }
      },
      {
        commands: %w[+duck +quack],
        url: "https://random-d.uk/api/v1/random?type=png",
        title: "Quack!",
        extract: ->(json) { json["url"] }
      },
      {
        commands: ["+panda"],
        url: "https://some-random-api.ml/img/panda",
        title: "Here, have a panda!",
        extract: ->(json) { json["link"] }
      },
      {
        commands: %w[+bird +birb],
        url: "https://some-random-api.ml/img/birb",
        title: "Tweet!",
        extract: ->(json) { json["link"] }
      },
      {
        commands: ["+koala"],
        url: "https://some-random-api.ml/img/koala",
        title: "A wild koala appears!",
        extract: ->(json) { json["link"] }
      },
      {
        commands: ["+sloth +slotho"],
        url: "https://sloth.pics/api",
        title: "Man, this API is kinda sloooow",
        extract: ->(json) { json["url"] }
      },
      {
        commands: %w[+cheems +doge],
        url: "http://shibe.online/api/shibes?count=1&urls=true",
        title: "Much picture, such wow",
        extract: ->(json) { json[0] }
      },
      {
        commands: ["+turtle +tortl"],
        url: "https://zelva.vrba.dev/api.php",
        title: "Tortl",
        extract: ->(json) { json["url"] }
      }
    ]
  end
end
