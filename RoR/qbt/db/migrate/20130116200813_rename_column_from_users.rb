class RenameColumnFromUsers < ActiveRecord::Migration
  def up
    add_column :users, :user_id, :string
    rename_column :users, :listening_habbits, :listening_habits
  end

  def down
    remove_column :users, :user_id
    rename_column :users, :listening_habits, :listening_habbits
  end
end
