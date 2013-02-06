class AddDetailsToProducts < ActiveRecord::Migration
  def change
    add_column :tasks, :task_order, :integer
    add_column :tasks, :device_type, :string
  end
end
