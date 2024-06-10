class CreateBirds < ActiveRecord::Migration[7.1]
  def change
    create_table :birds do |t|
      t.string :species
      t.string :scientific_name
      t.text :description
      t.string :habitat
      t.string :distribution
      t.string :img_url

      t.timestamps
    end
  end
end
