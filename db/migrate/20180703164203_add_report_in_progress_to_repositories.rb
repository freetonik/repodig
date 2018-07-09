class AddReportInProgressToRepositories < ActiveRecord::Migration[5.2]
  def change
    add_column :repositories, :report_in_progress, :boolean
  end
end
