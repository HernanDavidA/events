class AddViewsCountToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :views_count, :integer, default: 0
  end
end
