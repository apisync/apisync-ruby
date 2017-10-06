require "spec_helper"

RSpec.describe Apisync::Http::QueryString do
  subject { described_class.new(filters: filters) }

  describe "#to_s" do
    describe "filters" do
      context 'when filters is nil' do
        let(:filters) { nil }

        it 'returns nothing' do
          expect(subject.to_s).to eq ""
        end
      end

      context 'when including metadata only' do
        let(:filters) do
          {
            metadata: {
              customer_id: "abc",
              second_key: "xyz",
            }
          }
        end

        it "returns filter" do
          expect(subject.to_s).to eq(
            "filter[metadata][customer-id]=abc&filter[metadata][second-key]=xyz"
          )
        end
      end

      context 'when including attrs many levels deep' do
        let(:filters) do
          {
            level1: {
              level2: {
                level3: {
                  level4: {
                    key: "abc",
                  }
                }
              }
            }
          }
        end

        it "returns filter" do
          expect(subject.to_s).to eq(
            "filter[level1][level2][level3][level4][key]=abc"
          )
        end
      end

      context 'when including metadata and another attribute' do
        let(:filters) do
          {
            application_id: 'app_id',
            metadata: {
              customer_id: "abc",
              second_key: "xyz",
            }
          }
        end

        it "returns filter" do
          expect(subject.to_s).to eq(
            "filter[application-id]=app_id&filter[metadata][customer-id]=abc&filter[metadata][second-key]=xyz"
          )
        end
      end
    end
  end
end
