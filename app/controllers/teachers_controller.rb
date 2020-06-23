class TeachersController < ApplicationController
    get '/teachers/signup' do
        if logged_in? 
          redirect to '/appointments'
        else
          erb :'teachers/signup'
        end
      end
    
      post '/teachers/signup' do
        # {"name"=>"Kelsey White", "email"=>"kelsey.shiba@gmail.com", "password"=>"pepe1969"}
        if valid_params?
          teacher = Teacher.create(params[:teacher])
          session[:user_id] = teacher.id
          
          redirect to '/appointments'
        else
          flash[:message] = "Please signup by typing into all fields"
          redirect to '/teachers/signup'
        end
      end

      get '/teachers/login' do
        if logged_in?
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

        def valid_params?
          params[:teacher].none? do |k, v|
            v == ""
          end
        end
        
      end
end