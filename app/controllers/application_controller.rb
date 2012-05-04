class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  private
    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Mongoid::Errors::DocumentNotFound
        nil
      end
    end

    def user_signed_in?
      return true if current_user
    end

    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
    end

    def at_least_one_checked?
      #@user = User.find(params[:id])
      post_ids_raw = params[:post_ids]
      if post_ids_raw.nil?
        redirect_to user_path(@user), :alert => "Please check at least one post"
      else
        @post_ids = params[:post_ids]
      end
    end

    def tumblr_api
      @user = User.find(params[:id]) 

      tumblr_config = YAML.load(File.open("#{::Rails.root}/config/oauth.yml").read)

      Tumblr.configure do |config|
        config.consumer_key = tumblr_config['tumblr']['key']
        config.consumer_secret = tumblr_config['tumblr']['secret']
        #config.consumer_key = ENV["TUMBLR_KEY"]
        #config.consumer_secret = ENV["TUMBLR_SECRET"]
        config.oauth_token = @user.token
        config.oauth_token_secret = @user.secret
      end

      @client = Tumblr.new
      @blogs = @client.info["user"]["blogs"]
      @first_blog_name = @blogs.first["name"]
      @hostname = "#{@first_blog_name}.tumblr.com"
      @total_posts = @client.posts(@hostname)["blog"]["posts"]
      @first_blog_posts = @client.posts(@hostname, :limit => @total_posts)["posts"]
    end
end
