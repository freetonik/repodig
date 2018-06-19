class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :url
      t.string :name
      t.integer :stargazers_count
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :forks_count

      t.timestamps
    end
  end
end
