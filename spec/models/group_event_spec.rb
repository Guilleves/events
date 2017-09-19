require 'rails_helper'

RSpec.describe GroupEvent, type: :model do
  let!(:group_event) { create :group_event, state: "draft" }
  describe "duration" do
    subject { (group_event[:date_to] - group_event[:date_from]).to_i }
    it "is a positive integer" do
      expect(subject).to be_an(Integer)
    end
    it "date from is earlier than date_to" do
      expect(group_event[:date_from]).to be < (group_event[:date_to])
    end
  end

  describe "state" do
    let(:states) { ["draft", "published"] }
    it "is draft or published" do
      expect(states).to include(group_event[:state])
    end

    # it "isn't 'published' with at least one missing field " do
    #   expect(group_event).to raise_error("All fields must have a value")
    # end
  end



  # pending "add some examples to (or delete) #{__FILE__}"
end
