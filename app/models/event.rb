class Event < ActiveRecord::Base

   validates :url, :presence =>true, :uniqueness => true
   validates :title, :presence =>true
   validates :started_at, :presence =>true
   validates :ended_at, :presence =>true

   scope :start_from, -> from { where('started_at >= ?', from) }
   scope :only_connpass_events, -> { where('url like ?', '%connpass%') }
   scope :only_doorkeeper_events, -> { where('url like ?', '%doorkeeper%') }
 
end
