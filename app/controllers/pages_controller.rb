class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:planning]

  def planning
    @event = Event.new
  end
end
