class RemoveEditable < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :editable
  end
end
