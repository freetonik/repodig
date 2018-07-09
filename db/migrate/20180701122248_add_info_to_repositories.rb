class AddInfoToRepositories < ActiveRecord::Migration[5.2]
  def change
    add_column :repositories, :repo_url, :string

    add_column :repositories, :licence, :string
    add_column :repositories, :licence_url, :string

    add_column :repositories, :organization, :string
    add_column :repositories, :organization_url, :string
  end
end

