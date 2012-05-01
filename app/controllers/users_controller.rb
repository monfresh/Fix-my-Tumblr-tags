class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user?
  before_filter :at_least_one_checked?, :only => :edit_tags
  
  def index
    @users = User.paginate(:page => params[:page])
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

    #tumblr_config = YAML.load(File.open("#{::Rails.root}/config/oauth.yml").read)

    Tumblr.configure do |config|
      #config.consumer_key = tumblr_config['tumblr']['key']
      #config.consumer_secret = tumblr_config['tumblr']['secret']
      config.consumer_key = ENV["TUMBLR_KEY"]
      config.consumer_secret = ENV["TUMBLR_SECRET"]
      config.oauth_token = @user.token
      config.oauth_token_secret = @user.secret
    end

    client = Tumblr.new
    blogs = client.info["user"]["blogs"]
    @first_blog_name = blogs.first["name"]
    total_posts = client.posts("#{@first_blog_name}.tumblr.com")["blog"]["posts"]
    @first_blog_posts = client.posts("#{@first_blog_name}.tumblr.com", :limit => total_posts)["posts"]
  end


  def edit_tags
    @user = User.find(params[:id])

    client = Tumblr.new
    blogs = client.info["user"]["blogs"]
    name = blogs.first["name"]
    hostname = "#{name}.tumblr.com"
    @results = []

    post_ids.each do |id|
      id = id.to_i
      type = client.posts(hostname, {:id => id})["posts"].first["type"]
      date = client.posts(hostname, {:id => id})["posts"].first["date"]
      tags = client.posts(hostname, {:id => id})["posts"].first["tags"]
      tags.select{ |tag| tag.include? "-" }.each{ |tag| tag.gsub!("-"," ") }
      fixed_tags = tags.join(", ")
      

      case type
      when "text"
         body = client.posts(hostname, {:id => id})["posts"].first["body"]
        title = client.posts(hostname, {:id => id})["posts"].first["title"]
        
        text_result = client.edit(hostname, {:id => id, :tags => fixed_tags, :date => date, :body => body, 
                                        :title => (title unless title.nil?)}.delete_if{ |k,v| v.nil? })
        
        @results.push(text_result)
        sleep 2

      when "photo"
                caption = client.posts(hostname, {:id => id})["posts"].first["caption"]
                   link = client.posts(hostname, {:id => id})["posts"].first["link_url"]
        photoset_layout = client.posts(hostname, {:id => id})["posts"].first["photoset_layout"]
        
        photo_result = client.edit(hostname, {:id => id, :tags => fixed_tags, :date => date, :link => (link unless link.nil?), :photoset_layout => (photoset_layout unless photoset_layout.nil?), :caption => (caption unless caption.nil?)}.delete_if{ |k,v| v.nil? })
        @results.push(photo_result)
        sleep 2

      when "quote"
         quote = client.posts(hostname, {:id => id})["posts"].first["text"]
        source = client.posts(hostname, {:id => id})["posts"].first["source"]

        quote_result = client.edit(hostname, {:id => id, :tags => fixed_tags, :date => date,
                                        :quote => quote, 
                                        :source => (source unless source.nil?)}.delete_if{ |k,v| v.nil? })
        @results.push(quote_result)
        sleep 2

      when "link"
              title = client.posts(hostname, {:id => id})["posts"].first["title"]
                url = client.posts(hostname, {:id => id})["posts"].first["url"]
        description = client.posts(hostname, {:id => id})["posts"].first["description"]

        link_result = client.edit(hostname, {:id => id, :tags => fixed_tags, :date => date,
                                        :url => url, 
                                        :title => (title unless title.nil?), 
                                        :description => (description unless description.nil?)}.delete_if{ |k,v| v.nil? })
        @results.push(link_result)
        sleep 2

      when "chat"
               title = client.posts(hostname, {:id => id})["posts"].first["title"]
        conversation = client.posts(hostname, {:id => id})["posts"].first["body"]

        chat_result = client.edit(hostname, {:id => id, :tags => fixed_tags, :date => date, 
                                        :conversation => conversation, 
                                        :title => (title unless title.nil?)}.delete_if{ |k,v| v.nil? })
        @results.push(chat_result)
        sleep 2

      #when "audio"
        
      #       caption = client.posts(hostname, {:id => id})["posts"].first["caption"]
      #  external_url = client.posts(hostname, {:id => id})["posts"].first["source_url"]
      #     audio_url = client.posts(hostname, {:id => id})["posts"].first["audio_url"]

      #  result = client.edit(hostname, {:id => id, :tags => fixed_tags, :date => date, 
      #                                  :external_url => external_url, 
      #                                  :audio_url => (audio_url unless audio_url.nil?),
      #                                  :caption => (caption unless caption.nil?)}.delete_if{ |k,v| v.nil? })
      #  if result.nil?
      #    redirect_to root_path, :flash => {:error => "Hmm. We weren't able to fix your tags, but your original post hasn't been affected."}
      #  else 
      #    new_tags = client.posts(hostname, {:id => result["id"]})["posts"].first["tags"]
      #    hyphenated_tags = new_tags.select {|tag| tag.include? "-"}
      #    if hyphenated_tags = []
      #      redirect_to root_path, :notice => "Yay! Your tags have been fixed!"
      #    else
      #      redirect_to root_path, :flash => {:error => "Hmm. We weren't able to fix your tags. Please try again."}
      #    end
      #  end

      when "video"
        caption = client.posts(hostname, {:id => id})["posts"].first["caption"]

        video_result = client.edit(hostname, {:id => id, :tags => fixed_tags, :date => date, 
                                        :caption => (caption unless caption.nil?)}.delete_if{ |k,v| v.nil? })
        
        @results.push(video_result)
        sleep 2
        
      else
        redirect_to root_path, :flash => { :error => "Please provide a valid post type" }
      end

      @results.each do |result|
        unless result.empty?
          @result_type = client.posts(hostname, {:id => result["id"]})["posts"].first["type"]
          @result_url = client.posts(hostname, {:id => result["id"]})["posts"].first["post_url"]
          new_tags = client.posts(hostname, {:id => result["id"]})["posts"].first["tags"]
          @hyphenated_tags = new_tags.select {|tag| tag.include? "-"}
        end
      end
      

    end #post_ids loop
  
  end #edit_tags

end
