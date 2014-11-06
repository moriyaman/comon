class String
  def is_facebook_account?
    self.include?('www.facebook.com')
  end

  def is_twitter_account?
    self.include?('twitter.com')
  end

  def is_github_account?
    self.include?('github.com')
  end
 
  def is_linkedin_account?
    self.include?('www.linkedin.com')
  end
end
