class Admin::AttendancesController < AdminController
	before_action :set_event
	before_action :redirect_to_root, if: :not_admin?, only: [:index]

	def index
	end

	def new
		@users = User.all
  end

  def create
	  # Amount in cents
	  @amount = @event.price * 100

		stripe_customer_id = ""
	 	
		@attendance = Attendance.new(stripe_customer_id: stripe_customer_id, participant: params[:user_id], event: @event)
    if @attendance.save
			flash[:success] = "Votre participation à bien été prise en compte !"
			#redirect_to gossips_path
		else
			#@tags = Tag.all
			render new_event_attendance_path(@event)
    end
 

	rescue Stripe::CardError => e
		flash[:error] = e.message
		redirect_to new_event_attendance_path(@event)
	end

	def destroy
		@attendance = Attendance.find(params[:id])
    @attendance.destroy
    redirect_back(fallback_location: @event)
  end


	private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:event_id])
    end

    def not_admin?
      return @event.admin != current_user
    end

    def redirect_to_root
      redirect_to events_path
    end
end
