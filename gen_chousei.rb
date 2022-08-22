# frozen_string_literal: true

require_relative 'init_session'
require_relative 'send_message_to_discord'

now = Time.now
month = ARGV[0] || now.month
days_in_month = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
wd = [/Mon/, /Tue/, /Wed/, /Thu/, /Fri/, /Sat/, /Sun/]
wd_jp = %w[月 火 水 木 金 土 日]
str = ''
time = Time.new(now.year, month, 1, 0, 0, 0, '+09:00')

(1..days_in_month[month]).each do |_day|
  str += "#{time.strftime('%-m/%-d (%a)')}\n"
  time += 60 * 60 * 24
end

7.times { str.gsub! wd[_1], wd_jp[_1] }

session = init_session
session.visit '/schedule/newEvent/create'
session.fill_in 'name', with: "#{month}月"
session.fill_in 'kouho', with: str
session.find_button('createBtn').click
sleep 3

event_page = session.find_field('listUrl').value

SendMessageToDiscord.new(event_page).notify
