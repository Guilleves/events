class GroupEventsController < ApplicationController
  # before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @group_events = GroupEvent.all
    render :json => @group_events, :status => 200
    # render json: Project.where('owner_id = ?', @user.id)
    # json_response(@todos)
  end

  # POST /todos
  def create
    @group_event = GroupEvent.new(params[:group_event])
    @group_event.save
    render :json => @group_event, :status => 201
  end

  # GET /todos/:id
  def show
    @group_event = GroupEvent.find(params[:id])
    if @group_event
      render json: @group_event, :status => 200
    else
      render json: {"message":"Event not found"}, :status => 404
    end
  end

  # PUT /todos/:id
  def update
    @group_event = GroupEvent.find(params[:id])
    @group_event.update_attributes(params[:group_event])
    @group_event.save
    render :json => @group_event, :status => 204
  end

  # DELETE /todos/:id
  def destroy
    @group_event = GroupEvent.find(params[:id])
    if @group_event.destroy
      render json: {"message": "Deleted successfully"}, :status => 204
    end
  end

end
