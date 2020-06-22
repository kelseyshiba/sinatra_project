require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET']
  end

  get "/" do
    
    erb :welcome
  end

  helpers do 
        
    def student_logged_in?
      !!session[:user_id]
    end

    def student_current_user
      @current_user ||= Student.find(session[:user_id])
    end
    
  end

  

end
