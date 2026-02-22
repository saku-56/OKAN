require "line/bot"
unless Rails.env.test?
  LINE_BOT_CLIENT = Line::Bot::V2::MessagingApi::ApiClient.new(
    channel_access_token: Rails.application.credentials.dig(:line, :messaging_channel_access_token)
  )
end
