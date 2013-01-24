class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
	t.column :age,			:integer
	t.column :gender,		:string
	t.column :listening_habits,	:integer
	t.column :instrument_training, 	:integer
	t.column :theory_training,	:integer
	t.column :handedness,		:string
	t.column :tone_deaf,		:integer
	t.column :arrythmic,		:integer
      t.timestamps
    end
  end
end
