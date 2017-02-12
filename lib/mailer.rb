require "google/apis/gmail_v1"
require "google/api_client/client_secrets"
require "date"

class Mailer
  FROM = Date.today.prev_day.to_s
  TO = Date.today.next_day.to_s
  FILE = "tmp/ids"

  attr_reader :service, :user_id

  def initialize
    client = Google::APIClient::ClientSecrets.new({
      installed: {
        refresh_token: ENV["EMAIL_HUE_GOOGLE_REFRESH_TOKEN"],
        client_id: ENV["EMAIL_HUE_GOOGLE_CLIENT_ID"],
        client_secret: ENV["EMAIL_HUE_GOOGLE_CLIENT_SECRET"],
      }
    })

    @service = Google::Apis::GmailV1::GmailService.new
    @service.authorization = client.to_authorization

    @user_id = "me"
  end

  def any_new_messages?
    result = !(remote_messages - stored_messages).empty?

    update_locally_stored_messages(remote_messages)

    result
  end

  private def stored_messages
    messages = []
    return messages unless File.exist?(FILE)

    File.foreach(FILE) do |line|
      messages.push(line.gsub("\n", ""))
    end
    messages
  end

  private def remote_messages
    return @remote_messages if @remote_messages

    query = "is:unread after:#{FROM} before:#{TO}"
    result = service.list_user_messages(user_id, q: query)

    @remote_messages = result.messages.map { |r| r.id }
  end

  private def update_locally_stored_messages(ids)
    File.open(FILE, "w+") { |f| f.puts(ids) }
  end
end
