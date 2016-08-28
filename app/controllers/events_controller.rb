class EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = current_user.events
  end

  def show

  end

  def edit

  end

  def new
    @event = Event.new
    @events = []
    current_user.events.not_overlap.each do |event|
      start = event.start.to_s.chomp(event.start.to_s.match(/:\d{2}\sUTC/).to_s).split('-').join('/')
      stop = event.end.to_s.chomp(event.end.to_s.match(/:\d{2}\sUTC/).to_s).split('-').join('/')
      @events.append [DateTime.strptime(start, '%Y/%m/%d %H:%M').strftime('%d/%m/%Y %H:%M'), DateTime.strptime(stop, '%Y/%m/%d %H:%M').strftime('%d/%m/%Y %H:%M')]
    end
  end

  def create
    @event = Event.create(event_params)
    current_user.events << @event
  end

  def update
    @event.update(event_params)
  end

  def destroy

  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :start, :end, :color, :allDay, :durationEditable, :startEditable, :overlap)
  end

end
