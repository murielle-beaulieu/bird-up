class CreateSearchResults < ActiveRecord::Migration[7.1]
  def change
    create_table :search_results do |t|
      t.references :photo, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
