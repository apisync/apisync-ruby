require "spec_helper"

RSpec.describe Apisync::Resource do
  subject { described_class.new(:users, host: 'host', authorization: :api_key) }

  it "has a version number" do
    expect(Apisync::VERSION).not_to be nil
  end

  describe "#save" do
    context 'when id is not present' do
      it "dispatches call to http client using post" do
        expect(Apisync::HttpClient)
          .to receive(:post)
          .with(
            resource_name: :users,
            data: {
              attributes: {
                key: "value"
              }
            },
            options: {
              host: 'host',
              authorization: :api_key
            }
          )
        subject.save(attributes: { key: "value" })
      end
    end

    context 'when id is present' do
      it "dispatches call to http client using put" do
        expect(Apisync::HttpClient)
          .to receive(:put)
          .with(
            resource_name: :users,
            id: 'uuid',
            data: {
              id: 'uuid',
              attributes: {
                key: "value"
              }
            },
            options: {
              host: 'host',
              authorization: :api_key
            }
          )
        subject.save(id: 'uuid', attributes: { key: "value" })
      end
    end
  end

  describe "#get" do
    it "dispatches call to http client" do
      expect(Apisync::HttpClient)
        .to receive(:get)
        .with(
          resource_name: :users,
          id: 'uuid',
          filters: {
            key: "value"
          },
          options: {
            host: 'host',
            authorization: :api_key
          }
        )

      subject.get(id: 'uuid', authorization: :api_key, filters: {key: "value"})
    end
  end
end
