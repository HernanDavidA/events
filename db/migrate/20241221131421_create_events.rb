class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.date :start_time
      t.date :end_time
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end
