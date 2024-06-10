class SpottingsController < ApplicationController
  before_action :set_spotting, only: [:show, :edit, :update, :destroy]

  def index
    @spottings = Spotting.all
  end

  def show
  end

  def create
    @spotting = Spotting.new(spotting_params)
    @spotting.user = current_user.id

    @bird = Bird.find(params[:bird_id])
    @spotting.bird = @bird

    if @spotting.save
      redirect_to success_spottings_path
    else
      render :show_bird, status: unprocessable_entity
    end
  end

  def edit
  end

  def update

    if @spotting.update(spotting_params)
      redirect_to spottings_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @spotting.destroy
    redirect_to spottings_path
  end

  private

  def spotting_params
    params.require(:spotting).permit(:date, :location)
  end

  def set_spotting
    @spotting = Spotting.find(params[:id])
  end
end
