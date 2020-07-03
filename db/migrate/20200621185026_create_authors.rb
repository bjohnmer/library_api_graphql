class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :yob, null: false
      t.boolean :is_alive, default: true
      t.text :bio

      t.timestamps
    end
  end
end
