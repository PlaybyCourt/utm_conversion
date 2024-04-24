# frozen_string_literal: true

require "utm_conversion"
require "rack/test"

RSpec.describe UTMConversion do # rubocop:disable Metrics/BlockLength
  let(:app) { ->(env) { [200, env, []] } }
  let(:middleware) { UTMConversion::Capture::UTMParamsMiddleware.new(app) }
  let(:request) { Rack::MockRequest.new(middleware) }

  describe UTMConversion::Capture::UTMParamsMiddleware do
    context "with UTM parameters in the request" do
      let(:params) do
        {
          "utm_source" => "test_source",
          "utm_medium" => "test_medium",
          "utm_campaign" => "test_campaign"
        }
      end

      it "extracts UTM parameters and stores them in the session and storage adapter" do
        expect(UTMConversion.storage_adapter).to receive(:store).with(params, kind_of(String))
        response = request.get("/", params: params)
        expect(response.status).to eq(200)
        expect(request.env["rack.session"][:utm_data].data).to eq(params)
      end
    end

    context "without UTM parameters" do
      it "does not store anything in the session or storage adapter" do
        expect(UTMConversion.storage_adapter).not_to receive(:store)
        response = request.get("/")
        expect(response.status).to eq(200)
        expect(request.env["rack.session"][:utm_data]).to be_nil
      end
    end
  end

  describe UTMConversion::Session::UTMData do
    let(:utm_data) { { "utm_source" => "test", "utm_medium" => "test" } }

    it "stores UTM data in the session" do
      described_class.store(request.env["rack.session"], utm_data)
      expect(request.env["rack.session"][:utm_data].data).to eq(utm_data)
    end

    it "loads UTM data from the session" do
      request.env["rack.session"][:utm_data] = described_class.new(utm_data)
      expect(described_class.load(request.env["rack.session"]).data).to eq(utm_data)
    end
  end
end
