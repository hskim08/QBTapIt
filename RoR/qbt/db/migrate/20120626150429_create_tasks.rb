class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
	t.column :version_number,	:string
	t.column :song_id,		:string
	t.column :user_id,		:string
	t.column :session_id,		:string
	t.column :session_date,		:string
	t.column :experimenter_id,	:string
	t.column :tap_data,		:string
	t.column :position_data,	:string
	t.column :with_music,		:integer
	t.column :feedback,		:string
	t.column :song_familiarity,	:integer
      t.timestamps
    end
  end
end
