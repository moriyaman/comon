require 'mechanize'
require 'open-uri'
require 'nokogiri'
class Batch::Connpass

  BASE_URL="http://connpass.com/"

  class << self
    
    def get_events
      agent = Mechanize.new
      page = agent.get("#{BASE_URL}/api/v1/event/?count=100")
      json = JSON.parse(page.body)
    end

    def get_participants
      charset = nil
      html = open("http://connpass.com/event/#{event_id}/participation/#participants") do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
      doc.css('table.participants_table').each do |table|
        table.css('tr').each do |user|
          user_info = user.css('td.user')
          social_account = user.css('td.social')
          connpass_user_url = user_info.css('p.display_name').css('a').first["href"]
          user_name = user_info.css('p.display_name').css('a').first.text
          twitter_account_name = social_account.css('a')[0] ? social_account.css('a')[0]["href"].split('screen_name=')[1] : nil
          facebook_account_name = social_account.css('a')[1] ? social_account.css('a')[1]["href"].split('facebook.com/')[1] : nil
          github_account_name = social_account.css('a')[2] ? social_account.css('a')[2]["href"].split('github.com/')[1] : nil
        end
      end 
    end
  end
end
