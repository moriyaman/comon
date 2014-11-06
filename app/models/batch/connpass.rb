require 'mechanize'
require 'open-uri'
require 'nokogiri'
class Batch::Connpass

  BASE_URL="http://connpass.com"

  LT_PATICIPANT=1
  LT_ABSENTEE=2
  ORDINARY_PATICIPANT=3
  ORDINARY_ABSENTEE=4

  class << self
    
    def get_events
      agent = Mechanize.new
      page = agent.get("#{BASE_URL}/api/v1/event/?count=100")
      json = JSON.parse(page.body)
      json["events"].each do |event|
        Event.create({ url: event["event_url"], title: event["title"], address: event["address"], description: event["description"], started_at: event["started_at"], 
               ended_at: event["ended_at"], limit: event["limit"] }) 
      end
    end

    def get_participants
      Event.only_connpass_events.start_from(Time.now).find_each do |event|
        charset = nil
        begin
          html = open("#{event.url}participation/#participants") do |f|
            charset = f.charset
            f.read
          end
          doc = Nokogiri::HTML.parse(html, nil, charset)
          doc.css('table.participants_table').each do |table|
            status = self.status(table.css('tr').first.text)
            next if status.blank? 
            table.css('tr')[1..-1].each do |user|
              begin 
                user_info = user.css('td.user')
                social_account = user.css('td.social')
                connpass_user_url = user_info.css('p.display_name').css('a').first["href"]
                user_name = user_info.css('p.display_name').css('a').first.text
                twitter_account_name = social_account.css('a')[0] ? social_account.css('a')[0]["href"].split('screen_name=')[1] : nil
                facebook_account_name = social_account.css('a')[1] ? social_account.css('a')[1]["href"].split('facebook.com/')[1] : nil
                github_account_name = social_account.css('a')[2] ? social_account.css('a')[2]["href"].split('github.com/')[1] : nil
                user = User.connpass_url_is(connpass_user_url).first_or_initialize
                user.twitter = twitter_account_name unless user.twitter.present?
                user.facebook = facebook_account_name unless user.facebook.present?
                user.github = github_account_name unless user.github.present?
                user.save
                event_participant = EventParticipant.user_id_and_event_id_is(user.id, event.id).first_or_initialize
                event_participant.lt_flg = true if (status == LT_PATICIPANT || status == LT_ABSENTEE)
                event_participant.cancel_flg = true if (status == LT_ABSENTEE || status == ORDINARY_ABSENTEE)
                event_participant.save
              rescue
              end
            end
          end
        rescue
        end
      end 
    end
     
    def status(string)
      if string.include?('LT枠') && string.include?('参加者')
        return LT_PATICIPANT
      elsif string.include?('LT枠') && string.include?('キャンセル')
        return LT_ABSENTEE
      elsif string.include?('一般参加') && string.include?('参加者')
        return ORDINARY_PATICIPANT
      elsif string.include?('一般参加') && string.include?('キャンセル')
        return ORDINARY_ABSENTEE
      else
        return nil
      end
    end
  end
end
