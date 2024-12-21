class CreateUser < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username
      t.integer :permission_level, default: 0, null: false

      t.timestamps
    end
  end
end
