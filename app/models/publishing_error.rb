class PublishingError < StandardError
  # attr_reader :event
  # def initialize(msg="Error", thing="event")
  #   @event = event
  #   super(msg)
  # end
  #
  # begin
  #   raise PublishingError.new("Incomplete fields, can't publish", "event")
  # rescue => e
  #   puts e.event # "my thing"
end
