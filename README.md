## AI Mastering API tutorial

This is the AI Mastering API tutorial written in ruby.

[AI Mastering](https://aimastering.com)

[API docs](https://github.com/ai-mastering/aimastering-ruby#documentation-for-api-endpoints)

[API specification](https://app.swaggerhub.com/apis/aimastering/aimastering)

## Setup

```bash
# install dependencies
bundle install

# set access token (can be get from https://aimastering.com/app/developer)
export AIMASTERING_ACCESS_TOKEN=[AI Mastering API access token]
```

## Run

```bash
# Upload test.wav, do the mastering, download and save the output as output.wav 
bundle exec ruby main.rb --input test.wav --output output.wav
```

## License

CC0
