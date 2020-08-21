Rails.application.config.content_security_policy do |policy|
  policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
  policy.frame_src :self, "*.vimeo.com", "*.youtube.com", "*.vine.co", "*.instagram.com", "*.dailymotion.com", "*.youku.com"
end
