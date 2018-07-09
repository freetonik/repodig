class AnalyzeWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id
    repo.update_attribute :report_in_progress, true

    client = Octokit::Client.new :access_token => "d6e541654ef87bf2174f7b98948b204ca57cb389"
    client.auto_paginate = true

    ghrepo = client.repository repo.address

    # =====================
    # GENERAL INFO
    repo.update_attribute :stargazers_count, ghrepo.stargazers_count
    repo.update_attribute :forks_count, ghrepo.forks_count

    repo.update_attribute :about, ghrepo.description
    repo.update_attribute :repo_created_at, ghrepo.created_at
    repo.update_attribute :repo_updated_at, ghrepo.updated_at
    if ghrepo.license
      repo.update_attribute :license, ghrepo.license.name
      repo.update_attribute :license_url, ghrepo.license.url
    end

    # =====================
    # DOCUMENTATION
    begin
      @readme = client.readme repo.address
    rescue Exception => e
    end

    if @readme
      repo.update_attribute :readme_lenght, @readme.size
      repo.update_attribute :readme_url, @readme.html_url
    end

    repo.update_attribute :has_wiki, ghrepo.has_wiki

    # =====================
    # OWNER
    repo.update_attribute :owner, ghrepo.owner.login
    repo.update_attribute :owner_url, ghrepo.owner.html_url

    # =====================
    # OPEN ISSUES
    @open_issues = client.list_issues repo.address, state: 'open'

    repo.update_attribute :open_issues_count, @open_issues.count

    @time_now = Time.now
    @open_issues_ages = @open_issues.map { |x| @time_now - x.created_at }
    @open_issues_ages.extend(DescriptiveStatistics)

    repo.update_attribute :average_open_issue_age, @open_issues_ages.mean
    repo.update_attribute :median_open_issue_age, @open_issues_ages.median
    repo.update_attribute :min_open_issue_age, @open_issues_ages.min
    repo.update_attribute :max_open_issue_age, @open_issues_ages.max

    # =====================
    # CLOSED ISSUES
    @closed_issues = client.list_issues repo.address, state: 'closed'
    repo.update_attribute :closed_issues_count, @closed_issues.count

    @closed_issues_closing_periods = @closed_issues.map { |x| x.closed_at - x.created_at }
    @closed_issues_closing_periods.extend(DescriptiveStatistics)

    repo.update_attribute :average_issue_closing_time, @closed_issues_closing_periods.mean
    repo.update_attribute :median_issue_closing_time, @closed_issues_closing_periods.median
    repo.update_attribute :min_issue_closing_time, @closed_issues_closing_periods.min
    repo.update_attribute :max_issue_closing_time, @closed_issues_closing_periods.max

    @closed_issues_comments = @open_issues.map { |x| x.comments }
    @closed_issues_comments.extend DescriptiveStatistics

    if @closed_issues_comments.any?
        repo.update_attribute :average_number_of_comments_per_issue, @closed_issues_comments.mean
        repo.update_attribute :max_number_of_comments_per_issue, @closed_issues_comments.max
    else
        repo.update_attribute :average_number_of_comments_per_issue, 0
        repo.update_attribute :max_number_of_comments_per_issue, 0
    end

    # =====================
    # OPEN PULL REQUESTS
    @open_prs = client.pull_requests repo.address, state: 'open'
    repo.update_attribute :open_pr_count, @open_prs.count
    @time_now = Time.now

    @open_prs_ages = @open_prs.map { |x| @time_now - x.created_at }
    @open_prs_ages.extend DescriptiveStatistics

    repo.update_attribute :average_open_prs_age, @open_prs_ages.mean
    repo.update_attribute :median_open_prs_age, @open_prs_ages.median
    repo.update_attribute :min_open_prs_age, @open_prs_ages.min
    repo.update_attribute :max_open_prs_age, @open_prs_ages.max


    # =====================
    # CLOSED PULL REQUESTS
    @closed_prs = client.pull_requests repo.address, state: 'closed'
    repo.update_attribute :closed_pr_count, @closed_prs.count
    repo.update_attribute :pr_count, @open_prs.count + @closed_prs.count

    @closed_prs_closing_periods = @closed_prs.map { |x| x.closed_at - x.created_at }
    @closed_prs_closing_periods.extend(DescriptiveStatistics)

    repo.update_attribute :average_pr_closing_time, @closed_prs_closing_periods.mean
    repo.update_attribute :median_pr_closing_time, @closed_prs_closing_periods.median
    repo.update_attribute :min_pr_closing_time, @closed_prs_closing_periods.min
    repo.update_attribute :max_pr_closing_time, @closed_prs_closing_periods.max


    # =====================
    repo.update_attribute :analyzed, true
    repo.update_attribute :report_in_progress, false
  end
end
