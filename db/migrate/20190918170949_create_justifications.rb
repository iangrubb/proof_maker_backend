class CreateJustifications < ActiveRecord::Migration[6.0]
  def change
    create_table :justifications do |t|
      t.belongs_to :stage, null: false, foreign_key: true
      t.string :rule
      t.belongs_to :line, null: false, foreign_key: true

      t.timestamps
    end
  end
end
