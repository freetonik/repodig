class AnalyzeClosedIssuesWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id

    client = Octokit::Client.new access_token: 'd6e541654ef87bf2174f7b98948b204ca57cb389'

    # CLOSED ISSUES
    @closed_issues = client.list_issues repo.address, state: 'closed', per_page: 100

    @closed_issues_closing_periods = @closed_issues.map { |x| x.closed_at - x.created_at }
    @closed_issues_closing_periods.extend(DescriptiveStatistics)

    repo.update_attribute :average_issue_closing_time, @closed_issues_closing_periods.mean
    repo.update_attribute :median_issue_closing_time, @closed_issues_closing_periods.median
    repo.update_attribute :min_issue_closing_time, @closed_issues_closing_periods.min
    repo.update_attribute :max_issue_closing_time, @closed_issues_closing_periods.max

    @closed_issues_comments = @closed_issues.map { |x| x.comments }
    @closed_issues_comments.extend DescriptiveStatistics

    if @closed_issues_comments.any?
      repo.update_attribute :average_number_of_comments_per_issue,
                            @closed_issues_comments.mean
      repo.update_attribute :max_number_of_comments_per_issue,
                            @closed_issues_comments.max
    else
      repo.update_attribute :average_number_of_comments_per_issue, 0
      repo.update_attribute :max_number_of_comments_per_issue, 0
    end

    repo.update_attribute :closed_issues_count, @closed_issues.count

    FinalizeReportWorker.perform_async repo_id

  end
end
