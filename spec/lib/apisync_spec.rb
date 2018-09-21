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
          .with(:users, {host: nil, verbose: true, api_key: :api_key})
          .and_return(resource)

        expect(subject.users).to eq resource
      end
    end

    context 'when options are passed in' do
      it 'passes it along to the resource' do
        expect(Apisync::Resource)
          .to receive(:new)
          .with(:users, { host: 'http://users', verbose: true, api_key: api_key })
          .and_return(resource)

        subject.users(host: 'http://users', api_key: '123')
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
            .with(:users, { host: nil, verbose: true, api_key: :instance_key })

          subject.users
        end
      end

      context 'when instance key is not set' do
        let(:instance_key) { nil }

        it 'uses global_key' do
          expect(Apisync::Resource)
            .to receive(:new)
            .with(:users, { host: nil, verbose: true, api_key: :global_key })

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
            .with(:users, { host: nil, verbose: true, api_key: :instance_key })

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

  describe '.verbose' do

    context 'when global verbosity is set' do
      before do
        Apisync.verbose = true
      end

      it 'uses global verbosity' do
        expect(Apisync).to be_verbose
      end
    end

    context 'when global verbosity is false' do
      before do
        Apisync.verbose = false
      end

      it 'uses global verbosity' do
        expect(Apisync).not_to be_verbose
      end

      context 'instance overrides verbosity' do
        it 'overrides global verbosity' do
          expect(Apisync.new(api_key: 1, verbose: true).verbose).to eq true
        end
      end
    end
  end
end
