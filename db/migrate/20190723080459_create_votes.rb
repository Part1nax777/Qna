class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :rating, default: 0
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
