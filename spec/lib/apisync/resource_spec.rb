require "spec_helper"

RSpec.describe Apisync::Resource do
  let(:http_client) { instance_double(Apisync::HttpClient) }
  let(:options) { { host: 'host', api_key: :api_key } }

  subject { described_class.new(:inventory_items, options) }

  before do
    allow(Apisync::HttpClient)
      .to receive(:new)
      .with(resource_name: :inventory_items, options: options)
      .and_return(http_client)
  end

  it "has a version number" do
    expect(Apisync::VERSION).not_to be nil
  end

  describe "#save" do
    context 'when id is not present' do
      it "dispatches call to http client using post" do
        expect(http_client)
          .to receive(:post)
          .with(
            data: {
              attributes: {
                key: "value"
              },
              type: "inventory-items"
            },
            headers: {
              key: :value
            }
          )
        subject.save(attributes: { key: "value" }, headers: {key: :value})
      end
    end

    context 'when id is present' do
      it "dispatches call to http client using put" do
        expect(http_client)
          .to receive(:put)
          .with(
            id: 'uuid',
            data: {
              id: 'uuid',
              attributes: {
                key: "value"
              },
              type: "inventory-items"
            },
            headers: {
              key: :value
            }
          )
        subject.save(id: 'uuid', attributes: { key: "value" }, headers: {key: :value})
      end
    end
  end

  describe "#get" do
    it "dispatches call to http client" do
      expect(http_client)
        .to receive(:get)
        .with(
          id: 'uuid',
          filters: {
            key: "value"
          },
          headers: {
            key: :value
          }
        )

      subject.get(
        id: 'uuid',
        api_key: :api_key,
        filters: {key: "value"},
        headers: {key: :value}
      )
    end
  end
end
