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
          flash[:message] = "Please login or create an account"
          erb :'students/login'
        end
      end

      post '/students/login' do
        student = Student.find_by_email(params[:student][:email])
        if student && student.authenticate(params[:student][:password])
            session[:user_id] = student.id
            
            redirect to '/appointments'
          else
            flash[:message] = "Please create an account."
            redirect to '/students/login'
          end
      end

      get "/students/:id/appointments" do
        if student_logged_in?
            @student = Student.find_by_id(params[:id])
            
            erb :'students/show'
        else
          flash[:message] = "You must be logged in to view these appointments"
          redirect to 'students/login'
        end
    end
     
      
end