class TeachersController < ApplicationController
    get '/teachers/signup' do
        if teacher_logged_in? 
          redirect to '/appointments'
        else
          erb :'teachers/signup'
        end
      end
    
      post '/teachers/signup' do
        # {"name"=>"Kelsey White", "email"=>"kelsey.shiba@gmail.com", "password"=>"pepe1969"}
        teacher = Teacher.create(params[:teacher])
        session[:user_id] = teacher.id
      
        redirect to '/appointments'
      end

      get '/teachers/login' do
        if teacher_logged_in?
          redirect to '/appointments'
        else
          erb :'teachers/login'
        end
      end

      post '/teachers/login' do
        teacher = Teacher.find_by_email(params[:teacher][:email])
        if teacher && teacher.authenticate(params[:teacher][:password])
          session[:user_id] = teacher.id

          redirect to '/appointments'
        else 
          #message please sign up for an account
          redirect to '/teachers/login'
        end
      end

      get '/teachers/logout' do
        
        erb :'students/logout'
      end

      post '/teachrs/logout' do
        session.clear
        redirect to '/'
      end

     

      helpers do 
        
        def teacher_logged_in?
          !!session[:user_id]
        end
    
        def teacher_current_user
          @current_user ||= Teacher.find(session[:user_id])
        end
        
      end
end