require "sinatra"
require "./sync_entry"

module FirmafonGcalSync
  class Api < Sinatra::Base
    configure :development do
      use Rack::Reloader
    end

    before do
      content_type :json
    end

    get "/" do
      redirect INFO_URL
    end

    post "/" do
      entry = SyncEntry.new(params)

      if entry.save
        [200, JSON.dump(delete_link: "#{request.scheme}://#{request.host_with_port}/delete/#{entry.token}")]
      else
        [422, JSON.dump(errors: entry.errors.full_messages)]
      end
    end

    get "/delete/:token" do
      entry = SyncEntry.first(token: params[:token])

      if entry && entry.destroy
        [200, "true"]
      else
        [404, "false"]
      end
    end
  end
end
