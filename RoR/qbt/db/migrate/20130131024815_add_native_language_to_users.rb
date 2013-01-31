class AddNativeLanguageToUsers < ActiveRecord::Migration
  def up
    add_column :users, :native_language, :string
		change_column :users, :listening_habits, :float
		change_column :users, :instrument_training, :float
		change_column :users, :theory_training, :float
  end
  
  def down
		change_column :users, :theory_training, :integer
		change_column :users, :instrument_training, :integer
		change_column :users, :listening_habits, :integer
  	remove_column :users, :native_language
  end
end
