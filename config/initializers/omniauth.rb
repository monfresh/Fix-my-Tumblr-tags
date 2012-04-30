Rails.application.config.middleware.use OmniAuth::Builder do
  provider :tumblr, ENV["TUMBLR_KEY"], ENV["TUMBLR_SECRET"]
end