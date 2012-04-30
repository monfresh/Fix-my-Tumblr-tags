#config = YAML.load(File.open("#{::Rails.root}/config/oauth.yml").read)

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :tumblr, config['tumblr']['key'], config['tumblr']['secret']
  provider :tumblr, ENV["TUMBLR_KEY"], ENV["TUMBLR_SECRET"]
end