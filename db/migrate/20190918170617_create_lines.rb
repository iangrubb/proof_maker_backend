class CreateLines < ActiveRecord::Migration[6.0]
  def change
    create_table :lines do |t|
      t.belongs_to :stage, null: false, foreign_key: true
      t.belongs_to :subproof, null: false, foreign_key: true
      t.integer :stage_order
      t.integer :goal_id
      t.jsonb :sentence

      t.timestamps
    end
  end
end
