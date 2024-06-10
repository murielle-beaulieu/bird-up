class CreateSpottings < ActiveRecord::Migration[7.1]
  def change
    create_table :spottings do |t|
      t.date :date
      t.string :location
      t.references :user, null: false, foreign_key: true
      t.references :bird, null: false, foreign_key: true

      t.timestamps
    end
  end
end
