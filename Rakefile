Dir.glob('lib/*.rb').each { |r| require_relative r }

namespace :email_hue do
  task :notifier do
     Notify.publish
  end
end
