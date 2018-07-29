require 'uri'
require 'net/http'
require 'json'
require 'engtagger'
require 'ostruct'

class Request
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def call(argument)
    uri = URI(url+"#{argument}")
    Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)
      json_resp = JSON.parse(response.body)
      OpenStruct.new(json_resp.first)
    rescue JSON::ParserError
      nil
    end
  end

end


puts "enter a sentence"
text = gets.chomp
request = Request.new("https://api.datamuse.com/words")

3.times do |i|

  tgr = EngTagger.new
  tagged = tgr.add_tags(text)
  nouns = tgr.get_nouns(tagged)

  
  nouns.keys.each do |word|

    response = request.call("?sp=#{word}&md=d")
    if response.respond_to?("defs")
      definition = response.defs.first.tap do |r|
        r.gsub!(/^[n]?/,"").gsub!(/^[adj]?{3}/,"").gsub!(/^[vbe]?{3}/,"").gsub!(/\t/, '')
      end
    else
      definition = word
    end

    text.gsub!(word,definition)
  end


  puts (i + 1).to_s + " - " + text

end
