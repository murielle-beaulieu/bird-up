class PhotosController < ApplicationController
  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      SearchResult.create!(
        user: current_user,
        photo: @photo
      ) # => creates search Result with status of :searching and triggers BackgroundJob Ai stuff
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
