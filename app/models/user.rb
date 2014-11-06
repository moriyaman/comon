require 'mechanize'
class User < ActiveRecord::Base
  
  SOCIAL_ACCOUNT=["facebook", "twitter", "github", "linkedin"]

  scope :connpass_url_is, -> connpass_url { where(connpass_url: connpass_url) }
  scope :facebook_is, -> facebook { where(facebook: facebook) }
  scope :twitter_is, -> twitter { where(twitter: twitter) }
  scope :github_is, -> github { where(github: github) }
  scope :linkedin_is, -> linkedin { where(linkedin: linkedin) }
  scope :has_social_account, -> { where('facebook is not null or twitter is not null or github is not null or linkedin is not null') }
  scope :have_not_rank, -> { where('github_rank is null and qiita_rank is null') } 

  def set_social_account(params)
    SOCIAL_ACCOUNT.each do |social_account|
      if eval("params[:#{social_account}]")
        eval("self.#{social_account} = params[:#{social_account}] if #{social_account}.blank?")
      end
    end
  end

  class << self
    def search_by_social_account(params)
      SOCIAL_ACCOUNT.each do |social_account|
        if eval("params[:#{social_account}]")
          eval("return #{social_account}_is(params[:#{social_account}]).first if #{social_account}_is(params[:#{social_account}]).exists?")
        end
      end
      return nil
    end

    def generate_technical_rank
      agent = Mechanize.new
      User.has_social_account.have_not_rank.find_each do |user|
        social_accounts = []
        social_accounts << user.facebook if user.facebook
        social_accounts << user.twitter if user.twitter
        social_accounts << user.github if user.github
        social_accounts << user.linkedin if user.linkedin
        social_accounts.each do |social_account|
          page = agent.get("https://job-share.net/api/technical_rank?name=#{social_account}")
          json = JSON.parse(page.body)
          if json["qiita_rank"] != "none" || json["github_rank"] != "none"
            user.qiita_rank = json["qiita_rank"] if json["qiita_rank"] != "none"
            user.github_rank = json["github_rank"] if json["github_rank"] != "none"
            user.save
            break
          end
        end
      end
    end
  end
end
