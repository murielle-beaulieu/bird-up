class CreateSearchResultBirds < ActiveRecord::Migration[7.1]
  def change
    create_table :search_result_birds do |t|
      t.references :search_result, null: false, foreign_key: true
      t.references :bird, null: false, foreign_key: true

      t.timestamps
    end
  end
end
