include UsersHelper

class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  skip_before_action :verify_authenticity_token

def index
  # Cachear todos los eventos
  @events = Rails.cache.fetch("events", expires_in: 10.minutes) do
    Event.all.to_a
  end

  @most_viewed_events = Rails.cache.fetch("most_viewed_events", expires_in: 10.minutes) do
    Event.order(views_count: :desc).limit(5)
  end

  respond_to do |format|
    format.html
    format.json do
      render json: {
        events: @events,
        most_viewed_events: @most_viewed_events
      }
    end
  end
end


  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    if admin_user?
      begin
        if @event.save
          respond_to do |format|
            format.html { redirect_to @event, notice: "Event was successfully created." }
            format.json { render :show, status: :created, location: @event }
          end
        else
          handle_error(@event.errors, :unprocessable_entity)
        end
      rescue StandardError => e
        handle_error({ error: "Something went wrong: #{e.message}" }, :internal_server_error)
      end
    else
      respond_to do |format|
        format.html { redirect_to events_path, notice: "You are not authorized to create events." }
        format.json { render json: { error: "You are not authorized to create events" }, status: :forbidden }
      end
    end
  end


  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    if admin_user?
      begin
        if @event.destroy
          respond_to do |format|
            format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
            format.json { head :no_content }
          end
        else
          handle_error(@event.errors, :unprocessable_entity)
        end
      rescue StandardError => e
        handle_error({ error: "Something went wrong: #{e.message}" }, :internal_server_error)
      end
    else
      respond_to do |format|
        format.html { redirect_to events_path, notice: "You are not authorized to delete events." }
        format.json { render json: { error: "You are not authorized to delete events" }, status: :forbidden }
      end
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :user_id)
    end

    def handle_error(errors, status)
      respond_to do |format|
        format.html { render :new, status: status, errors: errors }
        format.json { render json: errors, status: status }
      end
    end
end
