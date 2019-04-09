class InstallMailkick < ActiveRecord::Migration[5.2]
  def up
    create_table :mailkick_opt_outs do |t|
      t.string :email
      t.references :user, polymorphic: true
      t.boolean :active, null: false, default: true
      t.string :reason
      t.string :list
      t.timestamps
    end

    add_index :mailkick_opt_outs, :email
  end

  def down
    drop_table :mailkick_opt_outs
  end
end
