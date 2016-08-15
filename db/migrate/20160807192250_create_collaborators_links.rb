class CreateCollaboratorsLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :collaborators_links do |t|
      t.uuid :user_id
      t.uuid :collaborator_id
      t.timestamps
    end
  end
end
