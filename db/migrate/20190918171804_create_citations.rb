class CreateCitations < ActiveRecord::Migration[6.0]
  def change
    create_table :citations do |t|
      t.belongs_to :justification, null: false, foreign_key: true
      t.bigint :citeable_id
      t.string :citeable_type
      t.integer :citation_order

      t.timestamps
    end
    add_index :citations, [:citeable_type, :citeable_id]
  end
end
