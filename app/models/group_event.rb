class GroupEvent < ApplicationRecord
  include ActiveModel::AttributeAssignment
  @@states = [ "draft", "published" ]

  attribute :state, :string, default: "draft"
  validate :dates_must_be_valid, :date_from_cant_be_past, :state_must_be_draft_or_published
  after_save :update_duration
  scope :published, -> { where(:state => "published") }
  scope :active, -> { where(:deleted => nil) }

  # Composed scope
  def self.published_active
    active.published
  end

  # Override to perform soft deletes
  def delete
    d = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
    self.update_attribute(:deleted, d)
  end

  # Validates all attributes before publishing
  def no_nil_attributes
    GroupEvent.attribute_names.without("deleted").each do |a|
      if self.send(a).blank?
        errors.add(:base, "All fields are required to publish an event")
        return false
      end
    end
    return true
  end

  def state_must_be_draft_or_published
    if @@states.include?(state)
      return true
    else
      errors.add(:state, "The state must be draft or published")
      return false
    end
  end

  def publish_event
    if no_nil_attributes
      self.state = "published"
      self.save!
    else
      return false
    end
  end

  def update_duration
    self[:duration] = nil if (date_from.blank? || date_to.blank?)
    self[:duration] = round_to_one((date_to - date_from).to_i) if (date_to && date_from).present?
  end

  def round_to_one(value)
    value.zero? ? 1 : value
  end

  def dates_must_be_valid
    return true if !(date_from && date_to)
    return true if date_from <= date_to
    errors.add(:base, "Start date must be previous to End date")
    return false
  end

  def date_from_cant_be_past
    return true if date_from.blank?
    return true if date_from >= Date.today
    errors.add(:date_from, "Start date can't be in the past")
    return false
  end
end

# A group event will be created by an user. The group event should run for a whole number of days e.g.. 30 or 60. There should be attributes to set and update the start, end or duration of the event (and calculate the other value). The event also has a name, description (which supports formatting) and location. The event should be draft or published. To publish all of the fields are required, it can be saved with only a subset of fields before it’s published. When the event is deleted/remove it should be kept in the database and marked as such.
