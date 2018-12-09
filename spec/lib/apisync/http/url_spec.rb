require "spec_helper"

RSpec.describe Apisync::Http::Url do
  let(:resource_name) { 'resource' }
  let(:id)            { nil }
  let(:filters)       { {} }
  let(:options)       { {host: nil} }

  subject do
    described_class.new(
      resource_name: resource_name,
      id: id,
      filters: filters,
      options: options
    )
  end

  describe "#to_s" do
    describe "host presence" do
      context 'when host is passed in' do
        let(:options) { {host: 'http://custom-host'} }

        it 'includes a host in the URL' do
          expect(subject.to_s).to eq 'http://custom-host/resource'
        end
      end

      context 'when host is not passed in' do
        let(:options) { {host: nil} }

        it 'does not include a host in the URL' do
          expect(subject.to_s).to eq 'https://api.apisync.io/resource'
        end
      end
    end

    describe 'resource name' do
      let(:resource_name) { :inventory_items }

      it "returns the final url with dasherized resource" do
        expect(subject.to_s).to eq 'https://api.apisync.io/inventory-items'
      end
    end

    describe 'id' do
      context 'when id is present' do
        let(:id) { 'uuid' }

        it 'adds it before the query string' do
          expect(subject.to_s).to eq 'https://api.apisync.io/resource/uuid'
        end
      end

      context 'when id is not present' do
        it 'does not include an id in the URL' do
          expect(subject.to_s).to eq 'https://api.apisync.io/resource'
        end
      end
    end

    describe 'querystring' do
      let(:filters) do
        {
          metadata: {
            customer_id: "abc"
          }
        }
      end

      it "returns the final url" do
        expect(subject.to_s).to eq 'https://api.apisync.io/resource?filter[metadata][customer_id]=abc'
      end
    end
  end
end
