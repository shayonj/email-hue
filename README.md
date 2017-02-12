## Email Hue

A simple script built to poll for new unread gmail messages and blink a Phillips Hue bulb, upon success :).


### Flow:

- A rake task that checks for unread messages in the past day.
- A copy of found unread messages (message ids) is stored as a text file in S3.
- Next it compares old messages vs new messages fetched from Gmail API.
- If there are new messages, a `PUT` request with params is sent to Philip hue bridge, exposed to a public domain.
- Which makes it 💡 (blink!)


Currently hosted on Heroku and scheduler that runs every 10 minutes, making this a Polling activity.

### Running:

- Install ruby
- Setup Google API credentials (be sure to get a refresh token) ([doc](https://developers.google.com/gmail/api/quickstart/ruby))
- Setup Aws S3
- Setup Philips Hue Bridge
  - Expose the internal bridge IP or be on the same network when running this locally. Since, Philips currently doesn't have a remote API for hue bridge
- `rake email_hue:notifier`

### ENV Vars:

- `EMAIL_HUE_GOOGLE_REFRESH_TOKEN`: Refresh token for your gmail account
- `EMAIL_HUE_GOOGLE_CLIENT_ID`: Gmail account/project client id
- `EMAIL_HUE_GOOGLE_CLIENT_SECRET`: Gmail account/project client secret
- `EMAIL_HUE_AWS_ACCESS_KEY`: Aws access key for S3
- `EMAIL_HUE_AWS_SECRET_KEY`: Aws secret key for S3
- `EMAIL_HUE_AWS_BUCKET_REGION`: Aws bucket region
- `EMAIL_HUE_AWS_BUCKET_NAME`: Aws bucket name
- `HUE_URL_WITH_PORT`: URL with port (if an) of Philips hue bridge (not internal IP)
- `HUE_USERNAME`: Philips hue bridge generated username
- `HUE_LIGHT_ID`: ID of the bulb

Philips has great documentation on [getting started](https://developers.meethue.com/documentation/getting-started) with Hue API.
