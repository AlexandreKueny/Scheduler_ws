class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:planning, :collaborators]
end