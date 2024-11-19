# frozen_string_literal: true
require "slack-notifier"

class SlackReportService
  def report
    @notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"], channel: "toy-app-report",
                                   username: "Toy app reporter"
    @notifier.post(blocks: report_data)
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
  def divider
    {
      type: 'divider'
    }
  end

  def header_section(text)
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: "*#{text}*"
      }
    }
  end

  def info_section(text)
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: text
      }
    }
  end

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
    info_section("The most commented post: http://localhost:3000/microposts/#{post[:id]}") if post.present?
  end

  def find_most_commented_post
    sql_query = <<-SQL
      WITH RECURSIVE comments AS (
        SELECT id, parent_id, id AS root_post_id
        FROM microposts
        WHERE parent_id IS NULL
  
        UNION ALL
  
        SELECT p.id, p.parent_id, d.root_post_id
        FROM microposts AS p
        INNER JOIN comments AS d ON p.parent_id = d.id
      )
      SELECT root_post_id AS id, COUNT(*) - 1 AS total_comments
      FROM comments
      GROUP BY root_post_id
      ORDER BY total_comments DESC
      LIMIT 1;
    SQL
    res = ActiveRecord::Base.connection.select_one(sql_query)
    res&.with_indifferent_access
  end
end
