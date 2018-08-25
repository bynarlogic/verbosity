require 'sinatra'
require './verbosity.rb'

include Verbosity

get '/sentence/:sentence/level/:level' do |s,l|
  response['Access-Control-Allow-Origin'] = '*'
  make_verbose(s, l.to_i)
end
