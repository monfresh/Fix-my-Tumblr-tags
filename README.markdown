# Fix My Tumblr Tags

Once a user signs in with their Tumblr account, this web app displays all the posts from the user's first blog that contain hyphenated tags (such as "hip-hop", "how-to", "gil scott-heron", etc.) and allows the user to edit those tags so that the hyphen is replaced with a space.

## Why?

At some point (late 2011, early 2012?), Tumblr stopped supporting hyphenated tags without any warning, explanation or remedy. Let's say you have a lot of posts tagged with "how-to", or a music blog with a lot of posts tagged with "hip-hop", and you want your visitors to easily find them all by adding a link on your blog that looks like this: [http://chezmoncef.com/tagged/how-to](http://chezmoncef.com/tagged/how-to). Well, as long as the tags contain hyphens, that link will result in "The URL you requested could not be found." The only solution is to replace the hyphen with a space (in the tag itself, not the URL).

I emailed Tumblr about this and they said they weren't planning on fixing it or providing an easy way for their users to find out which of their posts contain hyphenated tags, and then fix them all at once by replacing the hyphen with a space. Moreover, the Tumblr web interface still allows you to add hyphenated tags to new posts, even though they're no longer supported.

Since Tumblr wasn't going to do anything about this, I decided to learn Ruby and wrote this Rails app to fix my tags, and to allow everyone else to fix theirs.

## Which post types are supported?

As of April 26, 2012, all post types are supported, except for audio posts. There is a problem with the Tumblr v2 API that prevents audio posts from being edited. I have reported the bug to Tumblr and am waiting to hear back from them.

## Thanks

Many thanks to Daniel Kehoe for his awesome [RailsApps project](http://railsapps.github.com/). This app was generated with the [Mongoid and OmniAuth template](https://github.com/RailsApps/rails3-mongoid-omniauth). It also uses Jamie Wilkinson's [omniauth-tumblr gem](https://github.com/jamiew/omniauth-tumblr), and John Bunting's [tumblr_client gem](https://github.com/codingjester/tumblr_client) for easy communication with the Tumblr v2 API.

A full tutorial for putting this whole app together (once it's finished) will be posted on [http://moncefbelyamani.com](http://moncefbelyamani.com).

## Contributing

Feel free to fork this project and submit enhancements or code improvements.

## License

Copyright (c) 2012 Moncef Belyamani

This source code is released under an MIT license.