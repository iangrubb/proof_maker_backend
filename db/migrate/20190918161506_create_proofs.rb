class CreateProofs < ActiveRecord::Migration[6.0]
  def change
    create_table :proofs do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :ptype, null: false, foreign_key: true

      t.timestamps
    end
  end
end
