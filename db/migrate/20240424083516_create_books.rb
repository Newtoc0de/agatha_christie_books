class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :year
      t.boolean :read
      t.string :cover_url

      t.timestamps
    end
  end
end
