class AppointmentsController < ApplicationController
    get '/appointments' do
        
        erb :'appointments/index'
    end
    get '/appointments/new' do

        erb :'appointments/new'
    end

    get "/appointments/:user" do
        if student_logged_in? && student_current_user.name == params[:user]
            @student = student_current_user
            erb :'appointments/show'
        else
            redirect to 'students/login'
        end
    end

    post '/appointments' do
        if student_logged_in? && student_current_user
            params[:user] = student_current_user
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
            

            redirect to "/appointments/#{student_current_user.name}"
        else
            redirect to 'students/login'
        end
    end

    post '/appointments/:id/delete' do
        if student_logged_in? && student_current_user
            appt = Appointment.find_by_id(params[:id])
            appt.destroy

            redirect to "/appointments/#{student_current_user.name}"
        else
            redirect to '/students/login'
        end
    end

    get '/appointments/:id/edit' do
        if student_logged_in? && student_current_user
            @appointment = Appointment.find_by_id(params[:id])
            @student = student_current_user
            erb :'appointments/edit'
        else
            redirect to 'students/login'
        end
    end

    patch '/appointments/:id' do
        binding.pry
    end

end