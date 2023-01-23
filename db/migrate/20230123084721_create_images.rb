class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images, id: :uuid do |t|
      t.integer :status
      t.string :download_url
      t.references :user,
                   type: :uuid,
                   references: :users,
                   foreign_key: {
                     to_table: :users,
                   }

      t.timestamps
    end
  end
end
