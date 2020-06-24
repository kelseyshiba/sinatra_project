class AppointmentsController < ApplicationController
    get '/appointments' do
        @appointments = Appointment.all

        erb :'appointments/index'
    end

    get '/appointments/new' do
        if logged_in?
            erb :'appointments/new'
        else
            redirect to '/students/login'
        end
    end

    post '/appointments' do
        #{"appointment"=>{"week_number"=>"36", "day"=>"1", "time"=>"9", "name"=>"Drum Lesson"}, "student"=>{"name"=>"George"}}
        if valid_params?
            if logged_in?
                # chosen_date = Date.commercial(Time.now.year, params[:appointment][:week_number].to_i, params[:appointment][:day].to_i).to_s.gsub("-", " ").split
                # new = chosen_date.map {|integer| integer.to_i }
                # year = new[0]
                # month = new[1]
                # day = new[2]
                # time = params[:appointment][:time].to_i
                # start = DateTime.new(year, month, day, time)
                # ending = DateTime.new(year, month, day, time, 50)
                # week_number = params[:appointment][:week_number].to_i - 34
                # create_datetime(params)
                if student_current_user && is_student?
                    # @appointment = student_current_user.appointments.create(name: params[:appointment][:name], start: start, end: ending, week_number: week_number)
                    @appointment = student_current_user.appointments.create(create_datetime(params))
                    @teacher = Teacher.find_by(name: params[:teacher][:name])
                    @appointment.teacher_id = @teacher.id
                    student_current_user.teacher_id = @teacher.id
                    @appointment.save

                    redirect to "/appointments/#{@appointment.id}"
                elsif teacher_current_user && is_teacher?
                    @student = Student.find_by(name: params[:student][:name])
                    # @appointment = @student.appointments.create(name: params[:appointment][:name], start: start, end: ending, week_number: week_number)
                    @appointment = @student.appointments.create(create_datetime(params))
                    @appointment.teacher_id = teacher_current_user.id
                    @student.teacher_id = teacher_current_user.id
                    @appointment.save

                    redirect to "/appointments/#{@appointment.id}"
                else
                    flash[:message] = "This appointment has no owner"
                    redirect to '/appointments/new'
                end
            else
                flash[:message] = "You must be logged in to view"
                redirect to 'students/login'
            end
        else
            flash[:message] = "Please select a value for all fields"
            redirect to '/appointments/new'
        end
    end

    get '/appointments/:id' do
        if logged_in? 
            @appointment = Appointment.find_by_id(params[:id])
            @student = Student.find_by_id(@appointment.student_id)

            if @appointment 
              
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
        @student = @appointment.student
        @teacher = Teacher.find_by_id(@appointment.teacher_id)

        if logged_in?
            if student_current_user.id == @appointment.student_id || @teacher.id == teacher_current_user.id
               
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
        if logged_in? 
            @appointment = Appointment.find_by_id(params[:id])
            @teacher = Teacher.find_by_id(@appointment.teacher_id)
            if student_current_user.id == @appointment.student_id || teacher_current_user.id == @teacher.id 
        
                # chosen_date = Date.commercial(Time.now.year, params[:appointment][:week_number].to_i, params[:appointment][:day].to_i).to_s.gsub("-", " ").split
                # new = chosen_date.map do |integer|
                #     integer.to_i
                # end
                # year = new[0]
                # month = new[1]
                # day = new[2]
                # time = params[:appointment][:time].to_i
                # start = DateTime.new(year, month, day, time)
                # ending = DateTime.new(year, month, day, time, 50)
                # week_number = params[:appointment][:week_number].to_i - 34

                # @appointment.update(name: params[:appointment][:name], week_number: week_number, start: start, end: ending)
                @appointment.update(create_datetime(params))
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
    end

    delete '/appointments/:id/delete' do
        if logged_in? && student_current_user
            appt = Appointment.find_by_id(params[:id])
            appt.destroy

            redirect to "/appointments/#{student_current_user.name}"
        else
            redirect to '/students/login'
        end
    end

    helpers do 

        def valid_params?
            params[:appointment].none? do |k, v|
                v == ""
            end
        end

        def create_datetime(params)
            new_params = {}
            #{"appointment"=>{"week_number"=>"36", "day"=>"1", "time"=>"9", "name"=>"Drum Lesson"}, "student"=>{"name"=>"George"}}
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



