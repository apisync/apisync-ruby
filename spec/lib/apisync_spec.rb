require "spec_helper"

RSpec.describe Apisync do
  let(:api_key) { :api_key }

  subject { described_class.new(api_key: api_key) }

  it "has a version number" do
    expect(Apisync::VERSION).not_to be nil
  end

  describe "#(resource_name)" do
    let(:resource) { instance_double(Apisync::Resource) }

    context 'when no options are passed' do
      it "uses an abstract resource" do
        expect(Apisync::Resource)
          .to receive(:new)
          .with(:users, {authorization: :api_key})
          .and_return(resource)

        expect(subject.users).to eq resource
      end
    end

    context 'when options are passed in' do
      it 'passes it along to the resource' do
        expect(Apisync::Resource)
          .to receive(:new)
          .with(:users, { host: 'http://users', authorization: api_key })
          .and_return(resource)

        subject.users(host: 'http://users', authorization: '123')
      end
    end
  end
end
