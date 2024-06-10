class BirdsController < ApplicationController

  def show
    @bird = Bird.find(params[:id])
  end
end

# Person.find_or_create_by(name: 'Spartacus', rating: 4)
# returns the first item or creates it and returns it.
