class AddOpenIssuesStatsToRepository < ActiveRecord::Migration[5.2]
  def change
    add_column :repositories, :average_open_prs_age, :integer
    add_column :repositories, :median_open_prs_age, :integer
    add_column :repositories, :min_open_prs_age, :integer
    add_column :repositories, :max_open_prs_age, :integer
  end
end
