require "./api"
require "./background_synchronizer"

STDOUT.sync = true

FIRMAFON_APP_KEY = ENV["FIRMAFON_APP_KEY"]
INFO_URL = ENV["INFO_URL"] || "https://twitter.com/rasmusluckow/status/276057275586719744"

DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
DataMapper.auto_upgrade!

FirmafonGcalSync::BackgroundSynchronizer.run(ENV["INTERVAL"] || "2m")

run FirmafonGcalSync::Api
