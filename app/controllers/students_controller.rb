class StudentsController < ApplicationController

    get '/students/signup' do
        if student_logged_in? 
          redirect to '/appointments'
        else
          erb :'students/signup'
        end
      end
    
      post '/signup' do
        # {"name"=>"Kelsey White", "email"=>"kelsey.shiba@gmail.com", "password"=>"pepe1969"}
        student = Student.create(params[:student])
        session[:user_id] = student.id
      
        redirect to '/appointments'
      end

      get '/students/logout' do
        
        erb :'students/logout'
      end

      post '/students/logout' do
        session.clear
        redirect to '/'
      end
      
      get '/students/login' do
        if student_logged_in?

          redirect to '/appointments'
        else
          erb :'students/login'
        end
      end

      post '/students/login' do
        student = Student.find_by_email(params[:student][:email])
        if student && student.authenticate(:student[:password])
            session[:user_id] = student.id
            
            redirect to '/appointments'
          else
            #please create an account to login
            redirect to '/students/login'
          end
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