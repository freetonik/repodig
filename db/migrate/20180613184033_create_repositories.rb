class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :address
      t.string :about

      t.datetime :repo_created_at
      t.datetime :repo_updated_at
      t.datetime :last_commit_date

      t.integer :stargazers_count
      t.integer :forks_count
      t.integer :readme_lenght
      t.boolean :has_wiki

      t.integer :closed_issues_count
      t.integer :average_issue_closing_time
      t.integer :median_issue_closing_time
      t.integer :max_issue_closing_time
      t.integer :min_issue_closing_time
      t.integer :average_number_of_comments_per_issue

      t.integer :open_issues_count
      t.integer :average_open_issue_age
      t.integer :median_open_issue_age
      t.integer :max_open_issue_age
      t.integer :min_open_issue_age

      t.integer :pr_count
      t.integer :open_pr_count
      t.integer :closed_pr_count
      t.integer :average_pr_closing_time
      t.integer :median_pr_closing_time
      t.integer :max_pr_closing_time
      t.integer :min_pr_closing_time
      t.integer :average_number_of_comments_per_pr

      t.timestamps
    end
  end
end
