class EditJob < Struct.new(:user)
  def perform
    
		Tumblr.configure do |config|
			config.consumer_key = ENV["TUMBLR_KEY"]
			config.consumer_secret = ENV["TUMBLR_SECRET"]
			config.oauth_token = user.token
			config.oauth_token_secret = user.secret
		end

		@client = Tumblr.new
		blogs = @client.info["user"]["blogs"]
		first_blog_name = blogs.first["name"]
		@hostname = "#{first_blog_name}.tumblr.com"
  		
 		user.post_ids.each do |id|

 			id = id.to_i
     
			type = @client.posts(@hostname, {:id => id})["posts"].first["type"]
			date = @client.posts(@hostname, {:id => id})["posts"].first["date"]
			tags = @client.posts(@hostname, {:id => id})["posts"].first["tags"]

			tags.select{ |tag| tag.include? "-" }.each{ |tag| tag.gsub!("-"," ") }
      		fixed_tags = tags.join(", ")
      

      		case type
			when "text"
			 body = @client.posts(@hostname, {:id => id})["posts"].first["body"]
			title = @client.posts(@hostname, {:id => id})["posts"].first["title"]

			text_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date, :body => body, 
			                                :title => (title unless title.nil?)}.delete_if{ |k,v| v.nil? })

			while text_result.empty?
			  text_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date, :body => body, 
			                                :title => (title unless title.nil?)}.delete_if{ |k,v| v.nil? })
			end          
			


			when "photo"
			        caption = @client.posts(@hostname, {:id => id})["posts"].first["caption"]
			           link = @client.posts(@hostname, {:id => id})["posts"].first["link_url"]
			photoset_layout = @client.posts(@hostname, {:id => id})["posts"].first["photoset_layout"]

			photo_result= @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date, :link => (link unless link.nil?), :photoset_layout => (photoset_layout unless photoset_layout.nil?), :caption => (caption unless caption.nil?)}.delete_if{ |k,v| v.nil? })

			while photo_result.empty?
			  photo_result= @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date, :link => (link unless link.nil?), :photoset_layout => (photoset_layout unless photoset_layout.nil?), :caption => (caption unless caption.nil?)}.delete_if{ |k,v| v.nil? })
			end
			

			when "quote"
			 quote = @client.posts(@hostname, {:id => id})["posts"].first["text"]
			source = @client.posts(@hostname, {:id => id})["posts"].first["source"]

			quote_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date,
			                                :quote => quote, 
			                                :source => (source unless source.nil?)}.delete_if{ |k,v| v.nil? })
			while quote_result.empty?
			  quote_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date,
			                                :quote => quote, 
			                                :source => (source unless source.nil?)}.delete_if{ |k,v| v.nil? })
			end
			


			when "link"
			      title = @client.posts(@hostname, {:id => id})["posts"].first["title"]
			        url = @client.posts(@hostname, {:id => id})["posts"].first["url"]
			description = @client.posts(@hostname, {:id => id})["posts"].first["description"]

			link_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date,
			                                :url => url, 
			                                :title => (title unless title.nil?), 
			                                :description => (description unless description.nil?)}.delete_if{ |k,v| v.nil? })
			while link_result.empty?
			  link_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date,
			                                :url => url, 
			                                :title => (title unless title.nil?), 
			                                :description => (description unless description.nil?)}.delete_if{ |k,v| v.nil? })
			end
			


			when "chat"
			       title = @client.posts(@hostname, {:id => id})["posts"].first["title"]
			conversation = @client.posts(@hostname, {:id => id})["posts"].first["body"]

			chat_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date, 
			                                :conversation => conversation, 
			                                :title => (title unless title.nil?)}.delete_if{ |k,v| v.nil? })
			while chat_result.empty?
			  chat_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date, 
			                                :conversation => conversation, 
			                                :title => (title unless title.nil?)}.delete_if{ |k,v| v.nil? })
			end
			


			#when "audio"

			#       caption = @client.posts(@hostname, {:id => id})["posts"].first["caption"]
			#  external_url = @client.posts(@hostname, {:id => id})["posts"].first["source_url"]
			#     audio_url = @client.posts(@hostname, {:id => id})["posts"].first["audio_url"]

			#  audio_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date, 
			#                                  :external_url => external_url, 
			#                                  :audio_url => (audio_url unless audio_url.nil?),
			#                                  :caption => (caption unless caption.nil?)}.delete_if{ |k,v| v.nil? })


			when "video"
			caption = @client.posts(@hostname, {:id => id})["posts"].first["caption"]

			video_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date, 
			                                :caption => (caption unless caption.nil?)}.delete_if{ |k,v| v.nil? })

			while video_result.empty?
			  video_result = @client.edit(@hostname, {:id => id, :tags => fixed_tags, :date => date, 
			                                :caption => (caption unless caption.nil?)}.delete_if{ |k,v| v.nil? })
			end
			


			else
			redirect_to root_path, :flash => { :error => "Please provide a valid post type" }
			end

    	end #post_ids loop

	    
	end
end
