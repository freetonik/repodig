class AnalyzeClosedPrsWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id

    client = Octokit::Client.new access_token: '8efaaa3ac27d4abdda30d0bbe0ee3f4e4478a7a8'

    # =====================
    # CLOSED PULL REQUESTS
    @closed_prs = client.pull_requests repo.address, state: 'closed', per_page: 100

    @closed_prs_closing_periods = @closed_prs.map { |x| x.closed_at - x.created_at }
    @closed_prs_closing_periods.extend(DescriptiveStatistics)

    repo.update_attribute :average_pr_closing_time, @closed_prs_closing_periods.mean
    repo.update_attribute :median_pr_closing_time, @closed_prs_closing_periods.median
    repo.update_attribute :min_pr_closing_time, @closed_prs_closing_periods.min
    repo.update_attribute :max_pr_closing_time, @closed_prs_closing_periods.max

    repo.update_attribute :closed_pr_count, @closed_prs.count
    FinalizeReportWorker.perform_async repo_id
  end
end
