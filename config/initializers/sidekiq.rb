# Rails.application.config.after_initialize do
#   Turbo::Streams::BroadcastStreamJob.class_eval do
#     def self.perform_later(stream, content:)
#       super(stream, content: content.to_str)
#     end
#   end
# end

Sidekiq.strict_args!(false)
