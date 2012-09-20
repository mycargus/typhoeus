require 'spec_helper'

describe Typhoeus::Hydra::Memoizable do
  let(:url) { "localhost:3001" }
  let(:hydra) { Typhoeus::Hydra.new() }
  let(:request) { Typhoeus::Request.new(url, {:method => :get}) }

  describe "queue" do
    context "when memoization activated" do
      before { Typhoeus::Config.memoize = true }
      after { Typhoeus::Config.memoize = false }

      context "when request new" do
        it "sets no response" do
          hydra.queue(request)
          expect(request.response).to be_nil
        end

        it "doesn't call complete" do
          request.should_receive(:complete).never
          hydra.queue(request)
        end
      end

      context "when request in memory" do
        let(:response) { Typhoeus::Response.new }
        before { hydra.memory[request] = response }

        it "finishes request" do
          request.should_receive(:finish).with(response, true)
          hydra.queue(request)
        end
      end
    end
  end

  describe "#run" do
    it "clears memory before starting" do
      hydra.memory.should_receive(:clear)
      hydra.run
    end
  end
end
