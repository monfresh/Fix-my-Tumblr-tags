class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user?

  def index
    @users = User.paginate(:page => params[:page])
  end

    def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :edit
    end
  end


def show
    @user = User.find(params[:id])
    tumblr_config = YAML.load(File.open("#{::Rails.root}/config/oauth.yml").read)
    Tumblr.configure do |config|
      config.consumer_key = tumblr_config['tumblr']['key']
      config.consumer_secret = tumblr_config['tumblr']['secret']
      config.oauth_token = @user.token
      config.oauth_token_secret = @user.secret
    end
    client = Tumblr.new
    @blogs = client.info["user"]["blogs"]
    @first_blog_posts = client.posts("#{@blogs.first['name']}.tumblr.com")["posts"]
  end

end
