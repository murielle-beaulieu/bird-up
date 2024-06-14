class BirdsController < ApplicationController

  def show
    @bird = Bird.find(params[:id])
    @spotting = Spotting.new
    # raise
  end

end
