class RenameArrythmicInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :arrythmic, :arrhythmic
  end
end
