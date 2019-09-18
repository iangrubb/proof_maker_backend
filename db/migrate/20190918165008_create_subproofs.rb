class CreateSubproofs < ActiveRecord::Migration[6.0]
  def change
    create_table :subproofs do |t|
      t.belongs_to :stage, null: false, foreign_key: true
      t.integer :stage_order
      t.integer :subproof_id
      t.integer :goal_id

      t.timestamps
    end
  end
end
