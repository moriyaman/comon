class EventParticipant < ActiveRecord::Base

   validates :event_id, :presence =>true,
     :uniqueness => {:scope => [:user_id]}

   validates :user_id, :presence => true

   scope :user_id_and_event_id_is, -> user_id, event_id { where(user_id: user_id, event_id: event_id) }
 
end
