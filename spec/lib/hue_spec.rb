require './lib/hue'

RSpec.describe Hue do
  let(:hue) { Hue.new }
  before do
    allow(HTTParty).to receive(:put).and_return(true)
  end

  context "#new" do
    it "must set a valid class attributes" do
      expect(hue.hue_remote_api_ligths_url).not_to be_nil
    end
  end

  context "#blink!" do
    it "returns true when a new message is present" do
      expect(HTTParty).to receive(:put)
      hue.blink!
    end
  end
end
