class AddOwnerToRepositories < ActiveRecord::Migration[5.2]
  def change
    add_column :repositories, :owner, :string
    add_column :repositories, :owner_url, :string
  end
end
