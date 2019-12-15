class AnalyzeOpenIssuesWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id

    client = Octokit::Client.new access_token: '8efaaa3ac27d4abdda30d0bbe0ee3f4e4478a7a8'

    # =====================
    # OPEN ISSUES
    @open_issues = client.list_issues repo.address, state: 'open', per_page: 100

    @time_now = Time.now
    @open_issues_ages = @open_issues.map { |x| @time_now - x.created_at }
    @open_issues_ages.extend(DescriptiveStatistics)

    repo.update_attribute :average_open_issue_age, @open_issues_ages.mean
    repo.update_attribute :median_open_issue_age, @open_issues_ages.median
    repo.update_attribute :min_open_issue_age, @open_issues_ages.min
    repo.update_attribute :max_open_issue_age, @open_issues_ages.max

    repo.update_attribute :open_issues_count, @open_issues.count
    FinalizeReportWorker.perform_async repo_id
  end

end
