class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
	t.column :title,	:string
	t.column :artist,	:string
	t.column :year,		:integer
	t.column :ground_truth,	:string
      t.timestamps
    end
  end
end
