require "google/apis/gmail_v1"
require "google/api_client/client_secrets"
require "date"
require "aws-sdk"

class Mailer
  FROM = Date.today.prev_day.to_s
  TO = Date.today.next_day.to_s
  FILE = "ids"

  attr_reader :service, :user_id, :s3_file

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

    resource = Aws::S3::Resource.new(
      credentials: Aws::Credentials.new(ENV["EMAIL_HUE_AWS_ACCESS_KEY"], ENV["EMAIL_HUE_AWS_SECRET_KEY"]),
      region: ENV["EMAIL_HUE_AWS_BUCKET_REGION"]
    )

    @s3_file = resource.bucket(ENV["EMAIL_HUE_AWS_BUCKET_NAME"]).object(FILE)
  end

  def any_new_messages?
    result = !(remote_messages - stored_messages).empty?

    update_stored_messages(remote_messages)

    result
  end

  private def stored_messages
    return [] unless @s3_file.exists?

    @s3_file.get.body.read.split("\n")
  end

  private def remote_messages
    return @remote_messages if @remote_messages

    query = "is:unread after:#{FROM} before:#{TO}"
    result = service.list_user_messages(user_id, q: query)

    return [] if result.result_size_estimate == 0

    @remote_messages = result.messages.map { |r| r.id }
  end

  private def update_stored_messages(ids)
    @s3_file.put(body: ids.join("\n"))
  end
end
