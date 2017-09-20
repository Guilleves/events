class GroupEventsController < ApplicationController
  # GET /group_events
  def index
    @group_events = GroupEvent.all
    render :json => JSON.pretty_generate(@group_events.as_json), :status => 200
  end

  # POST /group_events
  def create
    @group_event = GroupEvent.new(group_event_params)
    @group_event.save
    render :json => @group_event, :status => 201
  end

  # GET /group_events/:id
  def show
    @group_event = GroupEvent.find(params[:id])
    if @group_event
      render json: @group_event, :status => 200
    else
      render json: {"message": "Event not found"}, :status => 404
    end
  end

  # PUT /group_events/:id
  def update
    @group_event = GroupEvent.find(params[:id])
    @group_event.update_attributes(group_event_params)
    @group_event.save
    render :json => @group_event, :status => 204
  end

  # DELETE /group_events/:id
  def destroy
    @group_event = GroupEvent.find(params[:id])
    if @group_event.delete
      render json: {"message": "Deleted successfully"}, :status => 204
    else
      render json: {"message": "Delete failed, event not found"}, :status => 404
    end
  end

  private
    def group_event_params
      params.require(:group_event).permit(:name, :description, :date_from, :date_to, location: [ :city, :zip_code, :address ])
    end

end
