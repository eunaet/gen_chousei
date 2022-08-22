require_relative 'init_session'
require_relative 'send_message_to_discord'

MINIMUM_ANSWER = 6
NOT_ENOUGH = '回答が3人未満です'

# td[0]:日程
# td[1..3]:○△✕
# td[4..]:回答
def visit_page(session, url)
  results = []
  session.visit(url)
  session.within(:id, 'tableArea') do
    session.all('tr').each do |tr|
      tds = tr.all('td').map(&:text)
      break unless tds.length > MINIMUM_ANSWER
      next unless %r{\d/\d}.match?(tds[0])
      next unless tds[3].to_i.zero?

      total = tds[1].to_i + tds[2].to_i
      results << { day: tds[0], total: total } unless total.zero?
    end
  end
  results
end

def result_text(results)
  return NOT_ENOUGH if results.empty?

  rank(results)
end

def rank(results)
  results.sort { |_a, b| b[:total] }
  result_txt = ''.tap do |str|
    str << "候補日ランキング\n"
    (0..2).each do |n|
      str << "#{n + 1}位: #{results[n][:day]}\n"
    end
  end
end

SendMessageToDiscord.new(result_text(visit_page(init_session, ARGV[0]))).notify
