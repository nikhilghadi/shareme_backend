class AddColumnsPins < ActiveRecord::Migration[7.0]
  def change
    add_column :pins, :user_id, :integer
    add_column :pins, :about, :string
    add_column :pins, :category, :string
    add_column :pins, :destination, :string

    add_column :pins, :saved, :integer, array:true, default:[]


  end
end
