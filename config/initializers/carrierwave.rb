CarrierWave.configure do |config|
  config.fog_provider = "fog/google"
  config.fog_credentials = {
    provider: "Google",
    google_project: ENV["GCP_PROJECT_NAME"],
    google_json_key_string: ENV["GCS_JSON_KEY"]
  }
  config.fog_directory = ENV["GCS_BUCKET_NAME"]
end
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
