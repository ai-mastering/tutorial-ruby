require 'aimastering'
require 'optparse'

# Parse command line arguments
options = {}
OptionParser.new do |opt|
  opt.on('-i', '--input VAL', 'Input audio file path') { |v| options[:input] = v }
  opt.on('-o', '--output VAL', 'Output audio file path') { |v| options[:output] = v }
  opt.parse!(ARGV)
end

# Setup authorization
Aimastering.configure do |config|
  # Configure API key authorization: bearer
  config.api_key['Authorization'] = ENV['AIMASTERING_ACCESS_TOKEN']
end

audio_api = Aimastering::AudioApi.new
mastering_api = Aimastering::MasteringApi.new

begin
  # Upload audio
  input_audio = File.open(options[:input]) do |input_file|
    audio_api.create_audio(
      file: input_file
    )
  end
  STDERR.puts 'Input audio created'
  STDERR.puts input_audio

  # Start the mastering
  mastering = mastering_api.create_mastering(
    input_audio.id,
    mode: 'default'
  )
  STDERR.puts 'Mastering created'
  STDERR.puts mastering

  # Wait for the mastering completion
  while mastering.status == 'processing' || mastering.status == 'waiting'
    mastering = mastering_api.get_mastering(mastering.id)
    STDERR.puts("waiting for the mastering completion #{(100 * mastering.progression).round}%")
    sleep(5)
  end

  # Download output audio
  output_audio_data = audio_api.download_audio(mastering.output_audio_id)
  File.binwrite(options[:output], output_audio_data)
  STDERR.puts "Output audio save to #{options[:output]}"
rescue Aimastering::ApiError => e
  STDERR.puts "Api error: #{e}"
end
