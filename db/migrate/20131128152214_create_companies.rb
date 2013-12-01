class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :country
      t.string :email
      t.string :phone

      t.timestamps
    end

    add_index :companies, :name
    add_index :companies, :city
  end
end
