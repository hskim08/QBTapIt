class RemoveSessionDateFromTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :session_date
    remove_column :tasks, :feedback
    add_column :tasks, :tap_off_data, :string
    add_column :tasks, :tap_x_data, :string
    add_column :tasks, :audio_helpful, :integer
    rename_column :tasks, :position_data, :tap_y_data
    change_column :tasks, :song_familiarity, :float
  end

  def down
    change_column :tasks, :song_familiarity, :integer
    rename_column :tasks, :tap_y_data, :position_data
    remove_column :tasks, :audio_helpful
    remove_column :tasks, :tap_x_data
    remove_column :tasks, :tap_off_data
    add_column :tasks, :feedback, :string
    add_column :tasks, :session_date, :string
  end
end
