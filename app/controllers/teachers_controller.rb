class TeachersController < ApplicationController
    get '/teachers/signup' do
        if logged_in? && is_teacher?
          redirect to '/appointments'
        else
          erb :'teachers/signup'
        end
      end
    
      post '/teachers/signup' do
        # {"name"=>"Kelsey White", "email"=>"kelsey.shiba@gmail.com", "password"=>"pepe1969"}
        sanitize_teacher_params

        if valid_params?
          teacher = Teacher.create(sanitize_teacher_params)
          session[:teacher_id] = teacher.id
          
          redirect to '/appointments'
        else
          flash[:message] = "Please signup by typing into all fields or enter a valid entry"
          redirect to '/teachers/signup'
        end
      end

      get '/teachers/login' do
        if logged_in? && is_teacher?
          redirect to '/appointments'
        else
          erb :'teachers/login'
        end
      end

      post '/teachers/login' do
        Sanitize.fragment(params[:teacher][:email])
        Sanitize.fragment(params[:teacher][:password])

        teacher = Teacher.find_by_email(params[:teacher][:email])
        if teacher && teacher.authenticate(params[:teacher][:password])
          session[:teacher_id] = teacher.id

          redirect to '/appointments'
        else 
          flash[:message] = "Please login or create an account"
          redirect to '/teachers/login'
        end
      end

      get '/teachers/logout' do
        if logged_in? && is_teacher?

          erb :'teachers/logout'
        else
          flash[:message] = "There is no user to logout"
          redirect to '/teachers/login'
        end
      end

      post '/teachers/logout' do
        session.clear
        redirect to '/'
      end

      get '/teachers/:id/appointments' do
        if logged_in? && is_teacher? 
          @teacher = Teacher.find_by_id(params[:id])
          
          erb :'teachers/show'  
        else
          flash[:message] = "You must be logged in to view"
          redirect to 'teachers/login'
        end
      end
     

      helpers do 

        def valid_params?
          sanitize_teacher_params.none? do |k, v|
            v == "" || v == " "
          end
        end

        def sanitize_teacher_params
          new_teacher_params = {}
          new_teacher_params[:name] = Sanitize.fragment(params[:teacher][:name])
          new_teacher_params[:email] = Sanitize.fragment(params[:teacher][:email])
          new_teacher_params[:password] = Sanitize.fragment(params[:teacher][:password])
          new_teacher_params
        end
        
      end
end