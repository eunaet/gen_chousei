# frozen_string_literal: true

require 'capybara'

month = ARGV[0].to_i
days_in_month = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
wd = [/Mon/, /Tue/, /Wed/, /Thu/, /Fri/, /Sat/, /Sun/]
wd_jp = %w[月 火 水 木 金 土 日]
str = ''
time = Time.new(2021, month, 1, 0, 0, 0, '+09:00')

(1..days_in_month[month]).each do |_day|
  str += "#{time.strftime('%-m/%-d (%a)')} 21:00 ~ \n"
  time += 60 * 60 * 24
end

7.times { str.gsub! wd[_1], wd_jp[_1] }

Capybara.threadsafe = true

session = Capybara::Session.new(:selenium_chrome_headless) do |config|
  config.run_server = false
  config.app_host = 'https://chouseisan.com/schedule/newEvent/create'
end
session.visit '/'
session.fill_in 'name', with: "#{month}月"
session.fill_in 'kouho', with: str
session.find_button('createBtn').click
sleep 3

event_page = session.find_field('listUrl').value

p event_page
