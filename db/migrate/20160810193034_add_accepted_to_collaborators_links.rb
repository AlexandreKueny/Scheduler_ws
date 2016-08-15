class AddAcceptedToCollaboratorsLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :collaborators_links, :accepted, :boolean, default: false
  end
end
