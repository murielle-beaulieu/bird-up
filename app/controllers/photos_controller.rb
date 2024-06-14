class PhotosController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      url = @photo.img.url
      redirect_to results_search_path
      else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:img)
  end
end
