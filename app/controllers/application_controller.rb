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

  not_found do
    status 404
    erb :error
  end

  get "/" do
    
    erb :welcome
  end

  helpers do 
        
    def logged_in?
      !!session[:user_id]
    end

    def student_current_user
      @student_current_user ||= Student.find_by_id(session[:user_id])
    end

    def teacher_current_user
      @teacher_current_user ||= Teacher.find_by_id(session[:user_id])
    end

    def is_teacher?
      #rely upon 
      !!teacher_current_user
      # session[:class].is_a?(Teacher)
    end

    def is_student?
      !!student_current_user
      # session[:class].is_a?(Student)
    end
    
  end

  

end
