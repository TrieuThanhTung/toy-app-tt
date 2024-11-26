require "slack-notifier"

class SlackReportService
  include SlackReport
  def initialize
    if ENV["SLACK_WEBHOOK_URL"]
      # Slack::Notifier is a gem that simplifies communication with Slack.
      # It abstracts the HTTP request details, so we don't need to manually handle
      # the formatting, headers, or network requests involved in sending a Slack message.
      @notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"], channel: "toy-app-report",
                                    username: "Toy app reporter"
    else
      raise StandardError, "Missing SLACK_WEBHOOK_URL"
    end
  end

  def report(report_data)
    @notifier.post(blocks: report_data)
  end

  def daily_report
    report(report_data)
  end

    def report_data
    yesterday = Date.yesterday
    yesterday_range = yesterday.all_day

    new_users = count_new_users(yesterday_range)
    new_posts = count_new_posts(yesterday_range)
    new_comments = count_new_comments(yesterday_range)

    [
      header_section("Yesterday's report: #{yesterday}"),
      divider,
      info_section("New users: #{new_users}"),
      info_section("New posts: #{new_posts}"),
      info_section("New comments: #{new_comments}"),
      most_commented_post_info(find_most_commented_post),
      divider
     ]
  end

  private

  def count_new_users(range)
    User.where(created_at: range).count
  end

  def count_new_posts(range)
    Micropost.where(parent_id: nil, created_at: range).count
  end

  def count_new_comments(range)
    Micropost.where.not(parent_id: nil).where(created_at: range).count
  end

  def most_commented_post_info(post)
    if ENV["HOST"] && post.present?
      info_section("The most commented post: #{ENV['HOST']}/#{post[:id]}")
    end
  end

  def find_most_commented_post
    sql_query =
      " WITH comments AS (
        SELECT m.parent_id AS parent_id, m.id AS id
        FROM microposts AS m
        JOIN microposts AS c ON m.id = c.parent_id
      )
      SELECT m.id, COUNT(*) as total_cmt
      FROM microposts AS m
      LEFT JOIN comments AS c ON m.id = c.parent_id
      GROUP BY m.id
      ORDER BY total_cmt DESC
      LIMIT 1; "
    res = ActiveRecord::Base.connection.select_one(sql_query)
    res&.with_indifferent_access
  end
end
