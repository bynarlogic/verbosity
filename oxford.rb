require 'uri'
require 'net/http'
require 'json'
require 'engtagger'

class Odapi
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def request(argument)
    uri = URI(url+"/#{argument}")
    Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)
      request["app_id"] = '529efe09'
      request["app_key"] = 'cbf2a51656df119c589ffa00ef559879'
      response = http.request(request)

      json_resp = JSON.parse(response.body)
    rescue JSON::ParserError
      nil
    end
  end

end


puts "enter a sentence"
text = gets.chomp

3.times do |i|

  tgr = EngTagger.new
  tagged = tgr.add_tags(text)
  nouns = tgr.get_nouns(tagged)

  odapi = Odapi.new("https://od-api.oxforddictionaries.com/api/v1/inflections/en")
  nouns = nouns.keys.map do |n|
    response = odapi.request(n)
    if response
      n = response["results"].first["lexicalEntries"].first["inflectionOf"].first["text"]
    else
      n
    end
  end


  nouns.each do |word|
    odapi = Odapi.new("https://od-api.oxforddictionaries.com/api/v1/entries/en")
    request = odapi.request(word)

    if request
      definition = request["results"].first["lexicalEntries"].first["entries"].first["senses"].first["short_definitions"].first
    else
      #definition not found use current word as definition
      definition = word
    end

    text.gsub!(word,definition)
  end


  puts (i + 1).to_s + " - " + text

end
