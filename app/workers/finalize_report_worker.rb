class FinalizeReportWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id

    # This is pretty ugly.
    # The approach is fine, but the implicit conditions are bad.
    # Checking if workers actually finished would be better.
    # Or maybe each worker's status should correspond to a field in DB

    if repo.owner_url &&
       repo.max_number_of_comments_per_issue &&
       repo.max_pr_closing_time &&
       repo.max_open_issue_age &&
       repomax_open_prs_age

      repo.update_attribute :analyzed, true
      repo.update_attribute :report_in_progress, false
    end
  end
end
