module SlackReport
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
end
