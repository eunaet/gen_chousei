require 'net/http'
require 'yaml'
require 'json'

class SendMessageToDiscord
  def initialize(content)
    @content = content
    @token = token
    @channel_id = channel_id
  end

  def notify
    url = URI.parse("https://discord.com/api/v10/channels/#{@channel_id}/messages")
    req = Net::HTTP::Post.new(url.path)
    req['Authorization'] = "Bot #{@token}"
    req['Content-Type'] = 'application/json'
    req.body = message_body
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    res = http.start do |_http|
      _http.request(req)
    end

    p res.code
  end

  def credentials
    @credentials ||= credentials_yaml
  end

  def credentials_yaml
    YAML.load(File.read('credentials.yml'))['credentials']
  rescue StandardError
    nil
  end

  def channel_id
    if credentials
      credentials['channel_id']
    else
      ENV['DISCORD_CHANNEL_ID']
    end
  end

  def token
    if credentials
      credentials['token']
    else
      ENV['DISCORD_TOKEN']
    end
  end

  def message_body
    JSON.generate({ content: @content })
  end
end
