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
    end

    # context 'when the record does not exist' do
    #   let(:group_event_id) { 'non_existent_id' }
    #
    #   it 'returns status code 404' do
    #     debugger
    #     expect(response).to have_http_status(404)
    #   end
    #
    #   it 'returns a not found message' do
    #     debugger
    #     expect(response.body.message).to match(/Event not found/)
    #   end
    # end
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
  end
end
