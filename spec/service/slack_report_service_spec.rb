require 'rails_helper'

RSpec.describe "SlackReportService" do
  let(:slack_notifier) { double("Slack::Notifier") }
  let(:report_service) { SlackReportService.new }

  before do
    allow(Slack::Notifier).to receive(:new).and_return(slack_notifier)
    allow(slack_notifier).to receive(:post)

    # Mock the methods that return report data
    allow(report_service).to receive(:count_new_users).and_return(5)
    allow(report_service).to receive(:count_new_posts).and_return(3)
    allow(report_service).to receive(:count_new_comments).and_return(10)
    allow(report_service).to receive(:find_most_commented_post).and_return({ id: 1, total_comments: 8 })
  end

  describe "#report" do
    it "sends a report to Slack" do
      expect(slack_notifier).to receive(:post).with(blocks: kind_of(Array))
      report_service.daily_report
    end
  end

  describe "#report_data" do
    it "includes the correct counts for new users, posts, and comments" do
      report_data = report_service.report_data

      expect(report_data).to include(
                               { text: { text: "New users: 5", type: "mrkdwn" }, type: "section" },
                               { text: { text: "New posts: 3", type: "mrkdwn" }, type: "section" },
                               { text: { text: "New comments: 10", type: "mrkdwn" }, type: "section" },
                               { text: { text: "The most commented post: http://localhost:3000/1", type: "mrkdwn" }, type: "section" }
                             )
    end
  end
end
