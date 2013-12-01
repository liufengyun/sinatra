class CreatePeople < ActiveRecord::Migration
  def change
    create_table :persons do |t|
      t.string :name
      t.string :passport_file_name
      t.integer :company_id

      t.timestamps
    end

    add_index :persons, :name
    add_index :persons, :company_id
  end
end
