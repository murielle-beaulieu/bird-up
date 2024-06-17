class SpottingsController < ApplicationController
  before_action :set_spotting, only: [:show, :edit, :update, :destroy, :success]

  def index
    @spottings = Spotting.where(user_id: current_user)

    @markers = @spottings.geocoded.map do |spotting|
      {
        lat: spotting.latitude,
        lng: spotting.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {spotting: spotting}),
        marker_html: render_to_string(partial: "marker")
      }
    end
  end

  def show
    @markers = [
      {
        lat: @spotting.latitude,
        lng: @spotting.longitude,
      }
    ]
  end

  def create
    @spotting = Spotting.new(spotting_params)
    @spotting.user_id = current_user.id

    if @spotting.save
      redirect_to success_spottings_path(@spotting)
    else
      render :show_bird, status: unprocessable_entity
    end
  end

  def edit
    @bird = Bird.find(@spotting.bird_id)
    @spotting.user_id = current_user.id

  end

  def update
    @spotting.user_id = current_user.id
    if @spotting.update(spotting_params)
      redirect_to spottings_path
    else
      render :edit_spotting, status: :unprocessable_entity
    end
  end

  def destroy
    @spotting.destroy
    redirect_to spottings_path
  end

  def success
    user_id = current_user.id
    @user_spottings = Spotting.where(user_id: user_id).count
  end

  def mapview
    @spottings = Spotting.where(user_id: current_user)
    @markers = @spottings.geocoded.map do |spotting|
      {
        lat: spotting.latitude,
        lng: spotting.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {spotting: spotting}),
        marker_html: render_to_string(partial: "marker")
      }
    end
  end

  private

  def spotting_params
    params.require(:spotting).permit(:date, :location, :bird_id, :user_id)
  end

  def set_spotting
    @spotting = Spotting.find(params[:id])
  end
end
