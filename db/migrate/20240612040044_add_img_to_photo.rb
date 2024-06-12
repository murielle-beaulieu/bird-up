class AddImgToPhoto < ActiveRecord::Migration[7.1]
  def change
    add_column :photos, :img, :string
  end
end
