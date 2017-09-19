class UpdateDateFromAndDateToDatatype < ActiveRecord::Migration[5.1]
  def change
    change_column :group_events, :date_from, :date
    change_column :group_events, :date_to, :date
  end
end
