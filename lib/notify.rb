Dir.glob('./*.rb').each { |r| require_relative r }

class Notify
  def self.publish
    should_publish = Mailer.new.any_new_messages?

    Hue.new.blink! if should_publish
  end
end
