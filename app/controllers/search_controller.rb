require "openai"
require 'wikipedia'
require 'json'
require 'open-uri'

class SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:results]
  def new
    # Nothing being passed in
    # Use new view for image upload
  end

  # GET /search/results?url=...
  def results
    # Grab the latest SearchResult (Job will be running in background for AI data)
    @search_result = current_user.search_results.last
  end

  private

  def new_params
    params.require(:new).permit(:photo)
  end
end
