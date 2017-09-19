class CreateGroupEvents < ActiveRecord::Migration[5.1]
  def change
    enable_extension "hstore"
    create_table :group_events do |t|
      t.text :name
      t.text :description
      t.timestamp :date_from
      t.timestamp :date_to
      t.integer :duration
      t.hstore :location
      t.text :state

      t.timestamps
    end
  end
end
