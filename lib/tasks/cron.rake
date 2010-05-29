task :cron => :environment do
  Cheepnis.maybe_stop
end
