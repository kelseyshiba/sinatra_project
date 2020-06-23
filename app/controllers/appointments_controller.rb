class AppointmentsController < ApplicationController
    get '/appointments' do
        @appointments = Appointment.all

        erb :'appointments/index'
    end

    get '/appointments/new' do
        if student_logged_in? 
            erb :'appointments/new'
        else
            redirect to '/students/login'
        end
    end

    post '/appointments' do
        if student_logged_in? && student_current_user
            chosen_date = Date.commercial(Time.now.year, params[:week_number].to_i, params[:day].to_i).to_s.gsub("-", " ").split
            new = chosen_date.map do |integer|
                integer.to_i
            end
            year = new[0]
            month = new[1]
            day = new[2]
            time = params[:time].to_i
            start = DateTime.new(year, month, day, time)
            ending = DateTime.new(year, month, day, time, 50)
            week_number = params[:week_number].to_i - 34
            
            @appointment = student_current_user.appointments.create(name: params[:name], start: start, end: ending, week_number: week_number)
            

            redirect to "/appointments/#{@appointment.id}"
        else
            flash[:message] = "You must be logged in to view"
            redirect to 'students/login'
        end
    end

    get '/appointments/:id' do
        if student_logged_in? 
            @student = student_current_user
            @appointment = Appointment.find_by_id(params[:id])
            if @appointment 
                erb :'appointments/show'
            else
                flash[:message] = "Sorry, no appointment exists with that ID"
                redirect to '/appointments'
            end
        else
            flash[:message] = "You must be logged in to view"
            redirect to '/students/login'
        end
    end

    get '/appointments/:id/edit' do
        @appointment = Appointment.find_by_id(params[:id])
        @student = @appointment.student
        if student_logged_in?
            if student_current_user.id == @appointment.student_id
               
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
        
        # {"_method"=>"patch", "appointment"=>{"week_number"=>"36", "name"=>"Piano Lesson", "day"=>"1", "time"=>"14"}, "id"=>"7"}
        if student_logged_in? 
            @appointment = Appointment.find_by_id(params[:id])
            if student_current_user.id == @appointment.student_id
        
                chosen_date = Date.commercial(Time.now.year, params[:appointment][:week_number].to_i, params[:appointment][:day].to_i).to_s.gsub("-", " ").split
                new = chosen_date.map do |integer|
                    integer.to_i
                end
                year = new[0]
                month = new[1]
                day = new[2]
                time = params[:appointment][:time].to_i
                start = DateTime.new(year, month, day, time)
                ending = DateTime.new(year, month, day, time, 50)
                week_number = params[:appointment][:week_number].to_i - 34

                @appointment.update(name: params[:appointment][:name], week_number: week_number, start: start, end: ending)
                @appointment.save

                redirect to "/appointments/#{@appointment.id}"
            else
                flash[:message] = "That appointment does not belong to you."
                redirect to "/appointments"
            end
        else
        end
    end

    delete '/appointments/:id' do
        if student_logged_in? && student_current_user
            appt = Appointment.find_by_id(params[:id])
            appt.destroy

            redirect to "/appointments/#{student_current_user.name}"
        else
            redirect to '/students/login'
        end
    end

    

end