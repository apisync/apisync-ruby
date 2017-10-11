require "spec_helper"

RSpec.describe Apisync::HttpClient do
  let(:host) { "https://api.apisync.io" }
  let(:options) { { api_key: 'api_key' } }
  let(:headers) do
    {
      "Content-Type"  => "application/vnd.api+json",
      "Accept"        => "application/vnd.api+json",
      "Authorization" => 'ApiToken api_key'
    }
  end

  subject { described_class.new(resource_name: 'inventory_items', options: options) }

  context 'when initialized with api_key' do
    let(:data) { { attributes: { } } }

    it "returns whatever is returned from Httparty" do
      stub_request(:post, "https://api.apisync.io/inventory-items")
        .with(
          body: {data: data}.to_json,
          headers: headers
        )

      response = subject.post(data: data)
      expect(response).to be_instance_of(HTTParty::Response)
    end
  end

  describe ".post" do
    let(:data) { { attributes: { my_attr: "value" } } }
    let(:payload) do
      {
        attributes: {
          "my-attr": "value"
        }
      }
    end

    it "returns whatever is returned from Httparty" do
      stub_request(:post, "https://api.apisync.io/inventory-items")
        .with(
          body: {data: payload}.to_json,
          headers: headers
        )

      response = subject.post(data: data)
      expect(response).to be_instance_of(HTTParty::Response)
    end

    it 'supports custom headers' do
      stub_request(:post, "https://api.apisync.io/inventory-items")
        .with(
          body: {data: payload}.to_json,
          headers: headers.merge("X-HEADER" => "custom value")
        )

      subject.post(
        data: data,
        headers: {
          "X-HEADER" => "custom value"
        }
      )
    end

    context 'when 429 is returned' do
      before do
        stub_request(:post, "https://api.apisync.io/inventory-items")
          .to_return(status: 429)
      end

      it 'raises TooManyRequests' do
        expect {
          subject.post(data: { id: :uuid })
        }.to raise_error Apisync::TooManyRequests
      end
    end
  end

  describe ".put" do
    let(:data)    { { id: 'uuid', attributes: { my_attr: "value" } } }
    let(:payload) do
      {
        id: 'uuid',
        attributes: {
          "my-attr": "value"
        }
      }
    end

    it "returns whatever is returned from Httparty" do
      stub_request(:put, "https://api.apisync.io/inventory-items/uuid")
        .with(
          body: {data: payload}.to_json,
          headers: headers
        )

      response = subject.put(id: 'uuid', data: data)
      expect(response).to be_instance_of(HTTParty::Response)
    end

    it 'supports custom headers' do
      stub_request(:put, "https://api.apisync.io/inventory-items/uuid")
        .with(
          body: {data: payload}.to_json,
          headers: headers.merge("X-HEADER" => "custom value")
        )

      subject.put(
        id: 'uuid',
        data: data,
        headers: {
          "X-HEADER" => "custom value"
        }
      )
    end

    context 'when passed in id is not the same as the payload id' do
      let(:data) { { id: 'uuid' } }

      it 'raises BadId' do
        expect do
          subject.put(
            id: 'different-uuid',
            data: data
          )
        end.to raise_error Apisync::UrlAndPayloadIdMismatch
      end
    end

    context 'when 429 is returned' do
      before do
        stub_request(:put, "https://api.apisync.io/inventory-items/uuid")
          .to_return(status: 429)
      end

      it 'raises TooManyRequests' do
        expect {
          subject.put(id: :uuid, data: { id: :uuid })
        }.to raise_error Apisync::TooManyRequests
      end
    end
  end

  describe ".get" do
    let(:expected_url) { "#{host}/inventory-items" }

    before do
      stub_request(:get, expected_url)
        .with(headers: headers)
    end

    context 'requesting by id' do
      let(:expected_url) { "#{host}/inventory-items/uuid" }

      it "returns whatever is returned from Httparty" do
        response = subject.get(id: 'uuid')
        expect(response).to be_instance_of(HTTParty::Response)
      end
    end

    context 'requesting by metadata' do
      let(:expected_url) { "#{host}/inventory-items?filter[metadata][customer-id]=abc" }

      it "returns whatever is returned from Httparty" do
        response = subject.get(
          filters: {
            metadata: {
              customer_id: "abc"
            }
          }
        )
        expect(response).to be_instance_of(HTTParty::Response)
      end
    end

    context 'when using custom headers' do
      let(:headers) do
        {
          "X-HEADER" => "custom value"
        }
      end

      it 'adds the headers' do
        subject.get(
          headers: {
            "X-HEADER" => "custom value"
          }
        )
      end
    end

    context 'when neither id nor filter was passed in' do
      let(:expected_url) { "#{host}/inventory-items" }

      it "returns all record from resource name" do
        subject.get
      end
    end

    describe 'exceptions' do
      context 'when 429 is returned' do
        before do
          stub_request(:get, "https://api.apisync.io/inventory-items")
            .to_return(status: 429)
        end

        it 'raises TooManyRequests' do
          expect {
            subject.get
          }.to raise_error Apisync::TooManyRequests
        end
      end

      context 'when filter was passed in not as hash' do
        it 'raises InvalidFilter' do
          expect do
            subject.get(filters: 2)
          end.to raise_error Apisync::InvalidFilter
        end
      end
    end
  end
end
