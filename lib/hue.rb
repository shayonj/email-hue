require "httparty"

class Hue
  attr_reader :hue_remote_api_ligths_url

  def initialize
    @hue_remote_api_ligths_url = "#{ENV["HUE_URL_WITH_PORT"]}/api/#{ENV["HUE_USERNAME"]}/lights/#{ENV["HUE_LIGHT_ID"]}/state"
  end

  def blink!
    HTTParty.put(hue_remote_api_ligths_url,
      body: {
        on: true,
        alert: "select"
      }.to_json,
      headers: {
        'Content-Type' => 'application/json'
      }
    )
  end
end
