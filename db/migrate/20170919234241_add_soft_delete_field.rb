class AddSoftDeleteField < ActiveRecord::Migration[5.1]
  def change
    add_column :group_events, :deleted, :boolean, null: false, default: false
  end
end
