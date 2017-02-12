require './lib/mailer'

RSpec.describe Mailer do
  let(:mailer) { Mailer.new }
  let (:new_remote_messages) { ["abc1234", "def5678", "ghi9012"] }
  let (:old_remote_messages) { ["abc1234", "def5678"] }

  before do
    allow(mailer).to receive(:remote_messages).and_return(new_remote_messages)
    allow(mailer).to receive(:stored_messages).and_return(old_remote_messages)
  end

  context "#constants" do
    it "TO constant should be defined" do
      expect(Mailer).to have_constant(:TO)
    end

    it "FROM constant should be defined" do
      expect(Mailer).to have_constant(:FROM)
    end

    it "FILE constant should be defined" do
      expect(Mailer).to have_constant(:FILE)
    end
  end

  context "#new" do
    it "must set a valid class attributes" do
      expect(Mailer.new.service).not_to be_nil
      expect(Mailer.new.user_id).not_to be_nil
    end
  end

  context "#any_new_messages?" do
    it "returns true when a new message is present" do
      expect(mailer.any_new_messages?).to eq(true)
    end

    it "returns false when stored messages match the remote messages found" do
      allow(mailer).to receive(:remote_messages).and_return(old_remote_messages)

      expect(mailer.any_new_messages?).to eq(false)
    end

    it "returns false when stored messages are present but remote messages returned empty (no new messages)" do
      allow(mailer).to receive(:remote_messages).and_return([])

      expect(mailer.any_new_messages?).to eq(false)
    end

    it "returns false when one of the messages from stored messages is no longer unread by remote " do
      allow(mailer).to receive(:remote_messages).and_return(new_remote_messages.first(2))

      expect(mailer.any_new_messages?).to eq(false)
    end

    it "returns true when there are no stored messages but remote messages returns all unread messages (first run)" do
      allow(mailer).to receive(:stored_messages).and_return([])

      expect(mailer.any_new_messages?).to eq(true)
    end
  end
end
