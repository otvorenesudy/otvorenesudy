require 'spec_helper'

shared_examples_for Api::Syncable do
  let(:api_key) { create :api_key }
  let(:factory) { repository.name.underscore.to_sym }
  let!(:records) { 101.times.map { FactoryGirl.create factory }.sort_by { |r| [r.updated_at, r.id] }}

  describe 'GET sync' do
    it 'returns records as json' do
      get :sync, api_key: api_key.value, format: :json

      json = ActiveModel::ArraySerializer.new(
        records.first(100),
        each_serializer: "#{repository}Serializer".constantize,
        root: repository.name.underscore.pluralize.to_sym,
        scope: controller
      ).to_json

      expect(response.headers['Content-Type']).to eql('application/json; charset=utf-8')
      expect(response.body).to eql(json)
    end

    it 'returns records sorted by updated_at and id' do
      get :sync, api_key: api_key.value, format: :json

      result = assigns(:records)

      expect(result.to_a).to eql(records.first(100))
    end

    it 'provides hypermedia API' do
      get :sync, api_key: api_key.value, format: :json

      link = url.call(since: records[99].updated_at.as_json, last_id: records[99].id, api_key: api_key.value)

      expect(response.headers['Link']).to eql("<#{link}>; rel='next'")
    end

    context 'with since parameter' do
      it 'returns records updated after provided date' do
        date = Time.now + 2.days

        other = 3.times.map { FactoryGirl.create factory, updated_at: date }

        get :sync, since: date.as_json, api_key: api_key.value, format: :json

        result = assigns(:records)

        expect(result.to_a).to eql(other)
      end
    end
  end
end
