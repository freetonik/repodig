class FinalizeReportWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id

    # This is pretty ugly.
    # The approach is fine, but the implicit conditions are bad.
    # Checking if workers actually finished would be better.
    # Or maybe each worker's status should correspond to a field in DB
    if repo.owner_url &&
       repo.closed_issues_count &&
       repo.closed_pr_count &&
       repo.open_issues_count &&
       repo.open_pr_count

      repo.update_attribute :analyzed, true
      repo.update_attribute :report_in_progress, false
    end
  end
end
