class AddSpecificTrainingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :specific_training, :string
  end
end
