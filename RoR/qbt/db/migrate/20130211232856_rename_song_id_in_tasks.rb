class RenameSongIdInTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :song_id, :song_title
  end
end
