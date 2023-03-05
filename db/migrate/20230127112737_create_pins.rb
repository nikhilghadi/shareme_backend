class CreatePins < ActiveRecord::Migration[7.0]
  def change
    create_table :pins do |t|
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
