class GroupEvent < ApplicationRecord
  include ActiveModel::AttributeAssignment

  validate :dates_must_be_valid

  def all_fields_must_be_completed_before_publishing
  end

  def dates_must_be_valid
    if date_from && date_to
      if date_from > date_to
        errors.add(:base, "Start date must be previous to End date")
        return false
      else return true
      end
    else return true
    end
  end
end

# A group event will be created by an user. The group event should run for a whole number of days e.g.. 30 or 60. There should be attributes to set and update the start, end or duration of the event (and calculate the other value). The event also has a name, description (which supports formatting) and location. The event should be draft or published. To publish all of the fields are required, it can be saved with only a subset of fields before it’s published. When the event is deleted/remove it should be kept in the database and marked as such.
