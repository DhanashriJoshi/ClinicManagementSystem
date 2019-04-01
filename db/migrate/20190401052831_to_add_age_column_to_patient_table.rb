class ToAddAgeColumnToPatientTable < ActiveRecord::Migration[5.2]
  def up
    add_column :patients, :age, :integer
  end

  def down
    remove_column :patients, :age
  end
end
