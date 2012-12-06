require "rufus-scheduler"
require "./sync_entry"

module FirmafonGcalSync
  class BackgroundSynchronizer
    def self.run(interval="2m")
      scheduler = Rufus::Scheduler.start_new

      scheduler.every interval do
        SyncEntry.all.each do |entry|
          begin
            print "Synchronizing #{entry.google_email}..."
            result = entry.do_not_disturb = entry.busy?
            puts " User is now #{result ? "busy" : "free"}"
          rescue => e
            puts e.inspect
          end
        end
      end
    end
  end
end
