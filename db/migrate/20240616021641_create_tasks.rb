class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    drop_table :tasks if table_exists?(:tasks)
    
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :due_date
      t.integer :status

      t.timestamps
    end
  end
end
