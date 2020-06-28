class AppointmentsController < ApplicationController
    get '/appointments' do
        @appointments = Appointment.all
        if logged_in?
            erb :'appointments/index'
        else
            flash[:message] = "Please login to view"
            redirect to '/'
        end
    end

    get '/appointments/new' do
        if logged_in?

            erb :'appointments/new'
        elsif is_student?
            redirect to '/students/login'
        else
            redirect to '/teachers/login'
        end
    end

    post '/appointments' do
        #{"appointment"=>{"week_number"=>"40", "day"=>"1", "time"=>"17", "name"=>"Piano Lesson", "student_id"=>"4"}}
        if valid_params?
            if logged_in?
                if is_student?
                    @appointment = student_current_user.appointments.create(change_params(params))
                    @appointment.teacher_id = params[:appointment][:teacher_id]
                    @appointment.save

                    redirect to "/appointments/#{@appointment.id}"
                elsif is_teacher?
                    @appointment = teacher_current_user.appointments.create(change_params(params))
                    @appointment.student_id = params[:appointment][:student_id]
                    @appointment.save

                    redirect to "/appointments/#{@appointment.id}"
                else
                    flash[:message] = "This appointment has no owner"
                    redirect to '/appointments/new'
                end
            else
                flash[:message] = "You must be logged in to view"
                redirect to '/'
            end
        else
            flash[:message] = "Please select a value for all fields"
            redirect to '/appointments/new'
        end
    end

    get '/appointments/:id' do 
        if logged_in? 
            @appointment = Appointment.find_by_id(params[:id])
            if @appointment 
                @student = Student.find_by_id(@appointment.student_id)
                erb :'appointments/show'
            else
                flash[:message] = "No appointment exists with that ID"
                redirect to '/appointments'
            end
        else
            flash[:message] = "You must be logged in to view"
            redirect to '/students/login'
        end
    end

    get '/appointments/:id/edit' do
        @appointment = Appointment.find_by_id(params[:id])
        @student = Student.find_by_id(@appointment.student_id)
        @teacher = Teacher.find_by_id(@appointment.teacher_id)
  
        if logged_in?
            if @teacher
               
                erb :'appointments/edit'
            elsif @student.id == student_current_user.id

                erb :'appointments/edit'
            else
                flash[:message] = "You may not edit someone else's appointment"
                redirect to '/appointments'
            end
        else
            flash[:message] = "You must be logged in to view this page."
            redirect to 'students/login'
        end
    end

    patch '/appointments/:id' do
        #{"_method"=>"patch", "appointment"=>{"week_number"=>"37", "name"=>"Piano Lesson", "day"=>"1", "time"=>"12"}, "student"=>{"name"=>"George"}, "id"=>"30"}
        @appointment = Appointment.find_by_id(params[:id])
        if valid_params?
            if logged_in?
                if is_student? && @appointment.student_id == student_current_user.id
                    @appointment.update(change_params(params))
                    @appointment.teacher_id = params[:appointment][:teacher_id]
                    @appointment.save

                    redirect to "/appointments/#{@appointment.id}"                   
                elsif is_teacher?
                    @appointment.update(change_params(params))
                    @appointment.student_id = params[:appointment][:student_id]
                    @appointment.save

                    redirect to "/appointments/#{@appointment.id}"
                else
                    flash[:message] = "That appointment does not belong to you."
                    redirect to "/appointments"
                end
            else
                flash[:message] = "You must be logged in to edit"
                redirect to "/appointments/#{@appointment.id}"
            end
        else
            flash[:message] = "Please select all fields"
            redirect to "/appointments/#{@appointment.id}/edit"
        end
    end

    delete '/appointments/:id/delete' do
        appointment = Appointment.find_by_id(params[:id])
        if logged_in?
            if is_student? && appointment.student_id == student_current_user.id
                appointment.destroy

                flash[:message] = "Deleted!"
                redirect to "/appointments"
            elsif is_teacher?
                appointment.destroy

                flash[:message] = "Deleted!"
                redirect to "/appointments"
            else
                flash[:message] = "This appointment does not exist"
                redirect to '/appointments'
            end
        else
            flash[:message] = "You must be logged in to delete"
            redirect to '/'
        end
    end

    helpers do 

        def valid_params?
            params[:appointment].none? do |k, v|
                v == ""
            end
        end

        def change_params(params)
            new_params = {}
            #{"appointment"=>{"week_number"=>"40", "day"=>"1", "time"=>"17", "name"=>"Piano Lesson", "student_id"=>"4"}}
            chosen_date = Date.commercial(Time.now.year, params[:appointment][:week_number].to_i, params[:appointment][:day].to_i).to_s.gsub("-", " ").split
            new = chosen_date.map {|integer| integer.to_i }
            year = new[0]
            month = new[1]
            day = new[2]
            time = params[:appointment][:time].to_i
            new_params[:start] = DateTime.new(year, month, day, time)
            new_params[:end] = DateTime.new(year, month, day, time, 50)
            new_params[:week_number] = params[:appointment][:week_number].to_i - 34
            new_params[:name] = params[:appointment][:name]
            new_params
        end
    end
    

end



