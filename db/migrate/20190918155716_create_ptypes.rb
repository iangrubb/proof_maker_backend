class CreatePtypes < ActiveRecord::Migration[6.0]
  def change
    create_table :ptypes do |t|
      t.jsonb :sentences

      t.timestamps
    end
  end
end
