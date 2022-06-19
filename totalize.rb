require 'capybara'
require 'webdrivers/chromedriver'
require_relative 'send_message_to_discord'

Capybara.threadsafe = true

session = Capybara::Session.new(:selenium_chrome_headless) do |config|
  config.run_server = false
  config.app_host = 'https://chouseisan.com'
end

results = []
session.visit ARGV[0]
session.within(:id, 'tableArea') do
  session.all('tr').each do |tr|
    tds = tr.all('td').map(&:text)
    next unless %r{\d/\d}.match?(tds[0])
    next unless tds[3].to_i.zero?

    total = tds[1].to_i + tds[2].to_i
    results << { day: tds[0], total: total } unless total.zero?
  end
end

results.sort { |_a, b| b[:total] }
result_txt = ''.tap do |str|
  str << "候補日ランキング\n"
  (0..2).each do |n|
    str << "#{n + 1}位: #{results[n][:day]}\n"
  end
end

puts result_txt

SendMessageToDiscord.new(result_txt).notify
