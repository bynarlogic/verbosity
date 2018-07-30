require 'sinatra'
require './verbosity.rb'

include Verbosity


get '/sentence' do
    make_verbose("Strangers in the night...", 2)
end

