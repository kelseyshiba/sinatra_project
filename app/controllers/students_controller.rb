class StudentsController < ApplicationController

    get '/students/signup' do
        if logged_in? 
          redirect to '/appointments'
        else
          flash[:message] = "Please sign up for an account"
          erb :'students/signup'
        end
      end
    
      post '/signup' do
        # {"name"=>"Kelsey White", "email"=>"kelsey.shiba@gmail.com", "password"=>"pepe1969"}
        if valid_params?
          student = Student.create(params[:student])
          session[:user_id] = student.id
      
          redirect to '/appointments'
        else
          flash[:message] = "Please enter something into all fields"
          redirect to '/students/signup'
        end
      end

      get '/students/logout' do
        if logged_in? 
          
          erb :'students/logout'
        else
          flash[:message] = "There is no one to logout"
          redirect to '/students/login'      
        end
      end

      post '/students/logout' do
        session.clear
        redirect to '/'
      end
      
      get '/students/login' do
        if logged_in?

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
        if logged_in?
            @student = Student.find_by_id(params[:id])
            
            erb :'students/show'
        else
          flash[:message] = "You must be logged in to view these appointments"
          redirect to 'students/login'
        end
    end

    helpers do 

      def valid_params?
        params[:student].none? do |k, v|
          v == ""
        end
      end
    end
     
      
end