class AddLocationToGroupEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :group_events, :location, :hstore, default: {}, null: true
  end
end
