class AppointmentsController < ApplicationController
    get '/appointments' do
        
        erb :'appointments/index'
    end

    post '/appointments' do
        binding.pry
        # {"tuesday"=>"on", "thursday"=>"on", "morning1"=>"on", "afternoon2"=>"on", "week_number"=>"15"}
        erb :'appointments/show'
    end
end