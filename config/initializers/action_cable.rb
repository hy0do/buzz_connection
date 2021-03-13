require 'action_cable/subscription_adapter/redis'

ActionCable::SubscriptionAdapter::Redis.redis_connector = ->(config) do
  config[:id] = "ActionCable-PID-#{$$}" unless config.has_key?(:id)
  ::Redis.new(config.except(:adapter, :channel_prefix))
end
