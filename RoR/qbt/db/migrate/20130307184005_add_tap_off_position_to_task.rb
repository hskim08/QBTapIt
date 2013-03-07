class AddTapOffPositionToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :tap_off_x_data, :string
    add_column :tasks, :tap_off_y_data, :string
  end
end
