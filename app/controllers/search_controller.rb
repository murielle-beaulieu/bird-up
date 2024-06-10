class SearchController < ApplicationController
  def new
    # Nothing being passed in
    # Use new view for image upload or keyword search
  end

  def results
    # Use OpenAI API for identification of bird
    # Receive JSON object and parse this response
    # Determine whether we have in database.
    # If we have in database, return the bird
    # Else create new bird records
  end
end
