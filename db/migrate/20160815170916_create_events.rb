class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events, id: :uuid do |t|
      t.uuid :user_id
      t.string :title, null: false, default: ''
      t.text :description
      t.boolean :allDay, default: false
      t.datetime :start
      t.datetime :end
      t.string :url
      t.boolean :editable, default: true
      t.boolean :startEditable, default: true
      t.boolean :durationEditable, default: true
      t.boolean :overlap, default: true
      t.string :color

      t.timestamps
    end
  end
end
