# firmafon-gcal-sync

Synchronize your Firmafon `do_not_disturb` with your Google Calendar account. When you have an event in your calendar, Firmafon is automatically set to do not disturb.

**NOTE** This is experimental software -- use at your own risk.

## I want to try it!

A version of `firmafon-gcal-sync` is running on Heroku. There is no interface, only a simple REST API. To sign up, you need [an application-specific password for your Google account](http://support.google.com/accounts/bin/answer.py?hl=en&answer=185833). Then simply `POST` to `http://firmafon-gcal-sync.herokuapp.com` with the following information:

- `google_email`: email of your Google Calendar account
- `google_password`: your application-specific password
- `google_app_name`: your application-specific name
- `firmafon_email`:  email of your Firmafon account
- `firmafon_password`: password for your Firmafon account (we don't store this!)

An example request would thus be:

    curl -d "google_email=andreas@subsis.com&google_password=xxx&google_app_name=yyy&firmafon_email=andreas@subsis.com&firmafon_password=zzz" http://firmafon-gcal-sync.herokuapp.com

You can use [this hurl](http://hurl.it/hurls/b6d2c944dc7ba336b851f8855bafdf7a3c0842a2/5ae2a1f270a5f229be9476394d13dcea7ef3ec7f) if you don't like CURL.

The server will respond with `200` and a delete link, which you can use to stop synchronizing again.

## How it works

The application periodically polls your Google Calendar using the [GCal v3 API](https://developers.google.com/google-apps/calendar/v3/reference/) to check if you're busy, and sets your Firmafon `do_not_disturb` accordingly with the [Firmafon API](http://firmafon.github.com/apidocs/). The default interval is 2 min between polls.

## Author
Andreas Garnæs<br/>
[www.subsis.com](http://www.subsis.com)
