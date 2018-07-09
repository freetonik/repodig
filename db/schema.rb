# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_09_154835) do

  create_table "repositories", force: :cascade do |t|
    t.string "address"
    t.string "about"
    t.datetime "repo_created_at"
    t.datetime "repo_updated_at"
    t.datetime "last_commit_date"
    t.integer "stargazers_count"
    t.integer "forks_count"
    t.integer "readme_lenght"
    t.boolean "has_wiki"
    t.integer "closed_issues_count"
    t.integer "average_issue_closing_time"
    t.integer "median_issue_closing_time"
    t.integer "max_issue_closing_time"
    t.integer "min_issue_closing_time"
    t.integer "average_number_of_comments_per_issue"
    t.integer "open_issues_count"
    t.integer "average_open_issue_age"
    t.integer "median_open_issue_age"
    t.integer "max_open_issue_age"
    t.integer "min_open_issue_age"
    t.integer "pr_count"
    t.integer "open_pr_count"
    t.integer "closed_pr_count"
    t.integer "average_pr_closing_time"
    t.integer "median_pr_closing_time"
    t.integer "max_pr_closing_time"
    t.integer "min_pr_closing_time"
    t.integer "average_number_of_comments_per_pr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "analyzed"
    t.string "repo_url"
    t.string "license"
    t.string "license_url"
    t.string "organization"
    t.string "organization_url"
    t.string "readme_url"
    t.integer "max_number_of_comments_per_issue"
    t.integer "max_number_of_comments_per_pr"
    t.string "owner"
    t.string "owner_url"
    t.boolean "report_in_progress"
    t.integer "average_open_prs_age"
    t.integer "median_open_prs_age"
    t.integer "min_open_prs_age"
    t.integer "max_open_prs_age"
  end

end
