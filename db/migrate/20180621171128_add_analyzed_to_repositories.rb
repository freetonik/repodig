class AddAnalyzedToRepositories < ActiveRecord::Migration[5.2]
  def change
    add_column :repositories, :analyzed, :boolean
  end
end
