class SpottingsController < ApplicationController

  def index
    @spottings = Spotting.all
  end

  def show
    @spotting = Spotting.find(params[:id])
  end

  def create
    @spotting = Spotting.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
