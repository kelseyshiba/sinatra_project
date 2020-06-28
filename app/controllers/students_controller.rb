class StudentsController < ApplicationController

    get '/students/signup' do
        if logged_in? && is_student?
          redirect to '/appointments'
        else
          erb :'students/signup'
        end
      end
    
      post '/students/signup' do
        # {"name"=>"Kelsey White", "email"=>"kelsey.shiba@gmail.com", "password"=>"pepe1969"}
        sanitize_params
  
        if valid_params?
          student = Student.create(sanitize_params)
          session[:student_id] = student.id
         
          redirect to '/appointments'
        else
          flash[:message] = "Please enter something into all fields or enter a valid entry"
          redirect to '/students/signup'
        end
      end

      get '/students/login' do
        if logged_in? && is_student?

          redirect to '/appointments'
        else
          erb :'students/login'
        end
      end

      post '/students/login' do
        Sanitize.fragment(params[:student][:email])
        Sanitize.fragment(params[:student][:password])

        student = Student.find_by_email(params[:student][:email])
        if student && student.authenticate(params[:student][:password])
            session[:student_id] = student.id

            redirect to '/appointments'
          else
            flash[:message] = "Please login or create an account."
            redirect to '/students/login'
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

      get "/students/:id/appointments" do
        if logged_in? && is_student?
            @student = Student.find_by_id(params[:id])
            
            erb :'students/show'
        else
          flash[:message] = "You must be logged in to view these appointments"
          redirect to 'students/login'
        end
    end

    helpers do 

      def valid_params?
        sanitize_params.none? do |k, v|
          v == "" || v == " "
        end
      end

      def sanitize_params
        new_student_params = {}
        new_student_params[:name] = Sanitize.fragment(params[:student][:name])
        new_student_params[:email] = Sanitize.fragment(params[:student][:email])
        new_student_params[:password] = Sanitize.fragment(params[:student][:password])
        new_student_params
      end
    end
     
      
end