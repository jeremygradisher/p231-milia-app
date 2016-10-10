class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :project_type
      t.string :square_footage
      t.text :description
      t.string :owner
      t.belongs_to :tenant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
