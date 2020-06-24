require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET']
    register Sinatra::Flash
  end

  get "/" do
    
    erb :welcome
  end

  helpers do 
        
    def logged_in?
      !!session[:user_id]
    end

    def student_current_user
      @current_user ||= Student.find(session[:user_id])
    end

    def teacher_current_user
      @current_user ||= Teacher.find(session[:user_id])
    end

    def is_teacher?
      session[:user_id] == teacher_current_user.id
    end

    def is_student?
      session[:user_id] == student_current_user
    end
    
  end

  

end
