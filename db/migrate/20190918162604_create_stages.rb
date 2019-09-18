class CreateStages < ActiveRecord::Migration[6.0]
  def change
    create_table :stages do |t|
      t.belongs_to :proof, null: false, foreign_key: true
      t.integer :parent_id

      t.timestamps
    end
  end
end
