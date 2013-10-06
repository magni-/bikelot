class AddDetailsToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :spots, :integer
    add_column :locations, :score, :integer
  end
end
