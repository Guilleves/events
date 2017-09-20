require 'rails_helper'
require 'byebug'

RSpec.describe GroupEvent, type: :model do
  let!(:group_event) { create :group_event }

  describe "duration" do
    subject { (group_event[:date_to] - group_event[:date_from]).to_i }

    it "is a positive integer" do
      expect(subject).to be_an(Integer)
    end
    context "when it has identical start and end dates" do
      let!(:event) { create :group_event, date_from: Date.today, date_to: Date.today}

      it "is 1" do
        expect(event.duration).to eq 1
      end
    end
  end

  describe "state" do
    let(:states) { ["draft", "published"] }

    it "is draft or published" do
      expect(states).to include(group_event[:state])
    end
  end
  context "when is published", focus: true do

    it "it has no blank attributes" do
      expect(group_event.no_nil_attributes).to eq true
    end
  end

  describe 'is invalid' do
    let(:invalid_event){ build :group_event, date_from: Date.today, date_to: Date.today - 3.days }

    it "it has incompatible dates" do
      expect(invalid_event).not_to be_valid
    end
  end

end
