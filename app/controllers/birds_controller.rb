class BirdsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @bird = Bird.find(params[:id])
    @spotting = Spotting.new
    # raise
  end

end
