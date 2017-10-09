require "spec_helper"

RSpec.describe Apisync::HttpClient do
  let(:host) { "https://api.apisync.io" }
  let(:headers) do
    {
      "Content-Type"  => "application/vnd.api+json",
      "Accept"        => "application/vnd.api+json"
    }
  end

  subject { described_class }

  context 'when initialized with api_key' do
    let(:data) { { attributes: { } } }

    it "returns whatever is returned from Httparty" do
      allow(HTTParty)
        .to receive(:post)
        .with(
          "https://api.apisync.io/inventory-items",
          body: {data: data}.to_json,
          headers: headers.merge("Authorization" => 'ApiToken api_key')
        )
        .and_return(:http_response)

      response = subject.post(
        resource_name: 'inventory_items',
        data: data,
        api_key: 'api_key'
      )
      expect(response).to eq :http_response
    end
  end

  describe ".post" do
    let(:data) { { attributes: { } } }

    it "returns whatever is returned from Httparty" do
      allow(HTTParty)
        .to receive(:post)
        .with(
          "https://api.apisync.io/inventory-items",
          body: {data: data}.to_json,
          headers: headers
        )
        .and_return(:http_response)

      response = subject.post(
        resource_name: 'inventory_items',
        data: data
      )
      expect(response).to eq :http_response
    end
  end

  describe ".put" do
    let(:data) { { id: 'uuid', attributes: { } } }

    it "returns whatever is returned from Httparty" do
      allow(HTTParty)
        .to receive(:put)
        .with(
          "https://api.apisync.io/inventory-items/uuid",
          body: {data: data}.to_json,
          headers: headers
        )
        .and_return(:http_response)

      response = subject.put(
        resource_name: 'inventory_items',
        id: 'uuid',
        data: data
      )
      expect(response).to eq :http_response
    end

    context 'when passed in id is not the same as the payload id' do
      let(:data) { { id: 'uuid' } }

      it 'raises BadId' do
        expect do
          subject.put(
            resource_name: 'inventory_items',
            id: 'different-uuid',
            data: data
          )
        end.to raise_error Apisync::UrlAndPayloadIdMismatch
      end
    end
  end

  describe ".get" do
    let(:expected_url) { "" }

    before do
      allow(HTTParty)
        .to receive(:get)
        .with(expected_url, headers: headers)
        .and_return(:http_response)
    end

    context 'looking by id' do
      let(:expected_url) { "#{host}/resources/uuid" }

      it "returns whatever is returned from Httparty" do
        response = subject.get(resource_name: 'resources', id: 'uuid')
        expect(response).to eq :http_response
      end
    end

    context 'looking by metadata' do
      let(:expected_url) { "#{host}/resources?filter[metadata][customer-id]=abc" }

      it "returns whatever is returned from Httparty" do
        response = subject.get(
          resource_name: 'resources',
          filters: {
            metadata: {
              customer_id: "abc"
            }
          }
        )
        expect(response).to eq :http_response
      end
    end

    context 'when neither id nor filter was passed in' do
      let(:expected_url) { "#{host}/some-resource" }

      it "returns all record from resource name" do
        subject.get(resource_name: 'some_resource')
      end
    end

    describe 'exceptions' do
      context 'when filter was passed in not as hash' do
        it 'raises InvalidFilter' do
          expect do
            subject.get(resource_name: 'some-name', filters: 2)
          end.to raise_error Apisync::InvalidFilter
        end
      end
    end
  end
end
