class CreateGroupEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :group_events do |t|
      t.string :name
      t.string :description
      #t.hash :running_time
      #t.hash :location
      t.string :state

      t.timestamps
    end
  end
end
