module Verbosity

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

    def make_verbose(text,qty)
        request = Request.new("https://api.datamuse.com/words")

        qty.times do |i|

          text.downcase!

          tgr = EngTagger.new
          tagged = tgr.add_tags(text)
          nouns = tgr.get_nouns(tagged)

          puts "nouns->"
          puts nouns.inspect


          nouns.keys.each do |word|

            response = request.call("?sp=#{word}&md=d")
            if response.respond_to?("defs")
              definition = response.defs.first.tap do |r|
                r.gsub!(/^[n]?/,"").gsub!(/^[adj]?{3}/,"").gsub!(/^[vbe]?{3}/,"").gsub!(/\t/, '')
              end
            else
              definition = word
            end

            definition = remove_articles(definition)

            text.gsub!(word,definition)
          end
        end

        text
    end


    def remove_articles(text)
      text.gsub(/\b[a]\b/," ").gsub(/\ban\b/," ").gsub(/\bthe\b/," ").gsub(/\s{2,}/," ")
    end

end
