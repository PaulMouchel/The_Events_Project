class Admin::EventsSubmissionsController < AdminController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.where(reviewed: false)
  end

  def show

  end

  def update #to validate
  	@event.reviewed = true
  	@event.validated = true
  	if @event.save
  		redirect_to admin_events_submissions_path
  	else
  		render :show
  	end
  end

  def destroy #to invalidate
  	@event.reviewed = true
  	@event.validated = false
  	if @event.save
  		redirect_to admin_events_submissions_path
  	else
  		render :show
  	end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:start_date, :duration, :title, :description, :price, :location, :event_pic)
  end
end
