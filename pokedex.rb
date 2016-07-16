
require 'telegram/bot'
require 'net/http'
require 'rest-client'
require 'json'
require 'open-uri'
token = 'Toke goes here'

puts "Ready to Go!"

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    pokemon_search = message.text
    case message.text
      when '/start'
        p "starting"
        bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{message.from.first_name}")
      when /pokemon/
        name = message.text
        name = name.split.last
        puts name
        url = 'http://pokeapi.co/api/v2/pokemon/'+name
        response = RestClient.get(url)
        data = JSON.parse(response)
        bot.api.send_message(chat_id: message.chat.id, text: "Información del Pokemon: #{data["name"].capitalize} 
          \n #{data["sprites"]["front_default"]} 
          \n Este pokemon es del tipo: #{data["types"][0]["type"]["name"].capitalize} 
          \n El ID de este Pokemon es el: #{data["id"]}")      
      when '/stop'
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end
