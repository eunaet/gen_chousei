month = ARGV[0].to_i
days_in_month = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
wd = [/Mon/, /Tue/, /Wed/, /Thu/, /Fri/, /Sat/, /Sun/]
wd_jp = ["月", "火", "水", "木", "金", "土", "日"]
str = ""
time = Time.new(2021,month,1,0,0,0,"+09:00")

(1..days_in_month[month]).each do |day|
  str += "#{time.strftime("%-m/%-d (%a)")} 21:00 ~ \n"
  time += 60*60*24
end

(0..6).each { str.gsub! wd[_1], wd_jp[_1] }

puts str
