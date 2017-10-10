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

  describe '.api_key=' do
    let(:global_key)   { :global_key }
    let(:instance_key) { :instance_key }

    subject { Apisync.new(api_key: instance_key) }

    before { Apisync.api_key = global_key }

    context 'when global key is set' do
      context 'when instance key is set' do
        it 'uses instance_key' do
          expect(Apisync::Resource)
            .to receive(:new)
            .with(:users, { authorization: :instance_key })

          subject.users
        end
      end

      context 'when instance key is not set' do
        let(:instance_key) { nil }

        it 'uses global_key' do
          expect(Apisync::Resource)
            .to receive(:new)
            .with(:users, { authorization: :global_key })

          subject.users
        end
      end
    end

    context 'when global key is NOT set' do
      let(:global_key) { nil }

      context 'when instance key is set' do
        it 'uses instance_key' do
          expect(Apisync::Resource)
            .to receive(:new)
            .with(:users, { authorization: :instance_key })

          subject.users
        end
      end

      context 'when instance key is not set' do
        let(:instance_key) { nil }

        it 'raises ArgumentError' do
          $debug = true
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end
end
