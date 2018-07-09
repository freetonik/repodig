class AddReadmeAndIssueCommentsToRepositories < ActiveRecord::Migration[5.2]
  def change
    add_column :repositories, :readme_url, :string
    add_column :repositories, :max_number_of_comments_per_issue, :integer
    add_column :repositories, :max_number_of_comments_per_pr, :integer
  end
end
