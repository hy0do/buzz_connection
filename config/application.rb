require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BuzzConnection
  class Application < Rails::Application
    config.load_defaults 6.1
    config.generators.template_engine = :slim

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.autoload_paths << Rails.root.join('lib', '**')
    %w[uploaders service serializers].each do |dir|
      config.autoload_paths << Rails.root.join('app', dir)
    end

    Bundler.require(*Rails.groups)
    Dotenv::Railtie.load
  end
end
