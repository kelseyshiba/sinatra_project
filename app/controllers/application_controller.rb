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
      !!session[:teacher_id] || session[:student_id]
    end

    def student_current_user
      @student_current_user ||= Student.find_by_id(session[:student_id])
    end

    def teacher_current_user
      @teacher_current_user ||= Teacher.find_by_id(session[:teacher_id])
    end

    def is_teacher?
      !!teacher_current_user
    end

    def is_student?
      !!student_current_user
    end
    
    def teacher_appointments
      Appointment.all.select do |appt|
          appt.teacher_id == teacher_current_user.id
      end.sort do |a,b|
        a.week_number <=> b.week_number
      end
    end

    def student_appointments
      Appointment.all.select do |appt|
        appt.student_id == student_current_user.id
      end.sort do |a, b|
        a.week_number <=> b.week_number
      end
    end

  end

  

end
