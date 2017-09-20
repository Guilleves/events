class ChangeDeletedToTime < ActiveRecord::Migration[5.1]
  def change
    remove_column :group_events, :deleted
    add_column :group_events, :deleted, :timestamp, default: nil
  end
end
