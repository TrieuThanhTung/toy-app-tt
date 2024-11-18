# frozen_string_literal: true
require "slack-notifier"

class SlackReportService
  def report
    @notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"], channel: "toy-app-report",
                                   username: "Toy app reporter"
    @notifier.post(blocks: report_data)
  end

  private
  def report_data
    yesterday = Date.yesterday
    user_registered_yesterday = User.where("created_at >= ? and created_at <= ?", 2.day.ago, 1.day.ago).count
    post_yesterday = Micropost.where("parent_id is null and created_at >= ? and created_at <= ?", 2.day.ago, 1.day.ago).count
    comment_yesterday = Micropost.where("parent_id is not null and created_at >= ? and created_at <= ?", 2.day.ago, 1.day.ago).count

    report_blocks = [
      {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "Hello, i'm a assistant reporter! \n\n *Report for yesterday: #{yesterday}* "
        }
      },
      {
        type: 'divider'
      },
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: "User registered: #{user_registered_yesterday}"
        }
      },
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: "Post: #{post_yesterday}"
        }
      },
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: "Comment: #{comment_yesterday}"
        }
      },
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: "The most commented post: http://localhost:3000/microposts/1."
        },
        accessory: {
          type: "button",
          text: {
            type: "plain_text",
            text: "Post here",
            emoji: true
          },
          url: "http://localhost:3000/microposts/1",
          action_id: "button-action"
        }
      },
      {
        type: 'divider'
      }
    ]
  end
end
