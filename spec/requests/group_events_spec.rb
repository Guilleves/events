require 'rails_helper'
require 'byebug'

RSpec.describe 'Group events API', type: :request do
  let!(:group_events) { create_list(:group_event, 3) }
  let(:group_event_id) { group_events.first.id }

  # Test suite for GET /group_events
  describe 'GET /group_events' do
    before { get '/group_events' }
    subject { JSON.parse(response.body) }

    it 'returns group events' do
      expect(subject).not_to be_empty
      expect(subject.size).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    describe "there are published events" do
      before { patch "/group_events/#{group_event_id}/publish" }
      before { get "/group_events?published=true" }
      subject { JSON.parse(response.body) }

      it 'returns published group events' do
        expect(subject).not_to be_empty
        expect(subject.size).to eq(1)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it "returns 1 event" do
        expect(GroupEvent.published_active.all.count).to eq 1
      end
    end
  end

  # Test suite for GET /group_events/:id
  describe 'GET /group_events/:id' do
    before { get "/group_events/#{group_event_id}" }
    subject { JSON.parse(response.body) }

    context 'when the record exists' do
      it 'returns the group_event' do
        expect(subject).not_to be_empty
        expect(subject['id']).to eq(group_event_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      describe "there are published events" do
        before { patch "/group_events/#{group_event_id}/publish" }
        before { get "/group_events?published=true" }
        subject { JSON.parse(response.body) }

        it 'has a published state' do
          expect(GroupEvent.find(group_event_id)[:state]).to eq "published"
        end
      end
    end
  end

  # Test suite for POST /group_events
  describe 'POST /group_events' do
    let(:valid_attributes) { { group_event: { name: 'Test event', description: 'An unexpected description' } } }

    context 'when the request is valid' do
      before { post '/group_events', params: valid_attributes }
      subject { JSON.parse(response.body) }

      it 'creates a group_event' do
        expect(subject['name']).to eq('Test event')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/group_events', params: {group_event: { date_to: Date.today - 3, date_from: Date.today } } }
      subject { JSON.parse(response.body) }

      it "the event is not saved" do
        expect(response).to have_http_status(400)
      end
    end
  end

  # Test suite for PUT /group_events/:id
  describe 'PUT /group_events/:id' do
    let(:valid_attributes) { { group_event: { name: 'Shopping' } } }
    let!(:event_duration) { GroupEvent.find(group_event_id)[:duration] }

    context 'when the record exists' do
      before { put "/group_events/#{group_event_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'saves the new attributes into the record' do
        expect(GroupEvent.find(group_event_id)[:name]).to eq "Shopping"
      end

      describe 'modify the dates' do
        let(:valid_attributes) { { group_event: { date_from: Date.today - 3.days } } }
        before { put "/group_events/#{group_event_id}", params: valid_attributes }
        subject { GroupEvent.find(group_event_id) }

        it "updates the duration" do
          expect(subject[:duration]).to eq (event_duration + 3)
        end
      end
    end
  end

  # Test suite for PATCH /group_events/:id/publish
  describe 'PATCH /group_events/:id/publish', focus: true do
    context 'when the event fields are complete' do
      before { patch "/group_events/#{group_event_id}/publish" }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'publishes the event' do
        expect(GroupEvent.find(group_event_id)[:state]).to eq "published"
      end
    end

    context "when the event's fields are incomplete" do
      let!(:incomplete_group_event) { create :group_event, name: nil }
      let(:incomplete_id) { incomplete_group_event.id }
      before { patch "/group_events/#{incomplete_id}/publish" }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'does not publish the event' do
        expect(GroupEvent.find(group_event_id)[:state]).to eq "draft"
      end
    end
  end

  # Test suite for DELETE /group_events/:id
  describe 'DELETE /group_events/:id' do
    before { delete "/group_events/#{group_event_id}" }

    it 'returns status code 204 (performs soft delete)' do
      expect(response).to have_http_status(204)
    end

    it "the record still exists and deleted is not nil" do
      ge = GroupEvent.find(group_event_id)
      expect(ge[:deleted]).not_to be nil
    end

    it "the records are hidden in the scope" do
      expect(GroupEvent.active.count).to eq 2
      expect(GroupEvent.count).to eq 3
    end
  end
end
