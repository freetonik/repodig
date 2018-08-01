class AddContributorsToRepositories < ActiveRecord::Migration[5.2]
  def change
    add_column :repositories, :contributors, :integer
    add_column :repositories, :contributors_incl_anon, :integer
  end
end
