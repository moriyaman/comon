require 'mechanize'
require 'open-uri'
require 'nokogiri'
class Batch::Doorkeeper

  BASE_URL="http://api.doorkeeper.jp"

  class << self
    
    def get_events
      (1..20).each do |page_num|
        agent = Mechanize.new
        page = agent.get("#{BASE_URL}/events?page=#{page_num}&since=#{Time.now.strftime('%Y-%m-%d')}")
        events = JSON.parse(page.body)
        break if events.blank?
        events.each do |event_hash|
          event = event_hash["event"] 
          Event.create({ url: event["public_url"], title: event["title"], address: event["address"], description: event["description"], started_at: event["starts_at"], ended_at: event["ends_at"], limit: event["ticket_limit"] }) 
        end
      end
    end

    def get_participants
      Event.only_doorkeeper_events.start_from(Time.now).find_each do |event|
        charset = nil
        #begin
          html = open("#{event.url}") do |f|
            charset = f.charset
            f.read
          end
          doc = Nokogiri::HTML.parse(html, nil, charset)
          doc.css('div.user-profile').each do |user_list|
            facebook, twitter, github, linkedin = nil, nil, nil, nil
            user_list.css('a.external-profile-link').each do |social_account|
              social_account = social_account["href"]
              if social_account.is_facebook_account?
                facebook = social_account.split('facebook.com/')[1]
              elsif social_account.is_twitter_account?
                twitter = social_account.split('twitter.com/')[1]
              elsif social_account.is_github_account?
                github = social_account.split('github.com/')[1]
              elsif social_account.is_linkedin_account?
                linkedin = social_account.split('linkedin.com/in/')[1]
              end
            end
            user = User.search_by_social_account({ facebook: facebook, twitter: twitter, github: github, linkedin: linkedin }).presence || User.new
            user.set_social_account({ facebook: facebook, twitter: twitter, github: github, linkedin: linkedin })
            p user
            user.save 
            event_participant = EventParticipant.user_id_and_event_id_is(user.id, event.id).first_or_initialize
            event_participant.save
          end
        #rescue
        #end
      end 
    end
  end
end
