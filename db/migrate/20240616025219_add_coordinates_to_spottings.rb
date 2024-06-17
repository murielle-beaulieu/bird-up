class AddCoordinatesToSpottings < ActiveRecord::Migration[7.1]
  def change
    add_column :spottings, :latitude, :float
    add_column :spottings, :longitude, :float
  end
end
