# Fix My Tumblr Tags

Work in progress.

Once a user signs in with their Tumblr account, this web app displays all the posts from the user's first blog that contain hyphenated tags (such as "hip-hop", "how-to", "gil scott-heron", etc.) and allows the user to edit those tags so that the hyphen is replaced with a space.

## Why?

Let's say you have a lot of posts tagged with "how-to", or a music blog with a lot of posts tagged with "hip-hop", and you want your visitors to easily find them all by adding a link on your blog that looks like this: [http://chezmoncef.com/tagged/how-to](http://chezmoncef.com/tagged/how-to). Well, as long as the tags contain hyphens, that link will result in "The URL you requested could not be found." Here are a couple of live examples: [http://spotify.tumblr.com/tagged/pre-release](http://spotify.tumblr.com/tagged/pre-release) and [http://spotify.tumblr.com/tagged/pre-stream](http://spotify.tumblr.com/tagged/pre-stream). The only solution is to replace the hyphen with a space (in the tag itself, not the URL).

Hyphenated tags used to work, but for some reason, Tumblr decided to stop supporting them. They have every right to make changes to their service, but such a change that affects their users' content must be properly communicated, and must include an acceptable solution. Unfortunately, this limitation is still not evident to a Tumblr user since the Tumblr web interface allows you to add hyphenated tags to posts. If a Tumblr user somehow discovers this problem, there is no way for them to find out which of their posts contain hyphenated tags, short of editing their posts one by one.

Maybe Tumblr will address this issue in the future, but I needed a solution yesterday. So, I wrote this Rails app to allow all Tumblr users to fix their tags. I hope you'll find it useful.

## Which post types are supported?

As of April 28, 2012, all post types are supported, except for audio posts. There is a problem with the Tumblr v2 API that prevents audio posts from being edited. I have reported the bug to Tumblr and am waiting to hear back from them.

## Thanks

Many thanks to Daniel Kehoe for his awesome [RailsApps project](http://railsapps.github.com/). This app was generated with the [Mongoid and OmniAuth template](https://github.com/RailsApps/rails3-mongoid-omniauth). It also uses Jamie Wilkinson's [omniauth-tumblr gem](https://github.com/jamiew/omniauth-tumblr), and John Bunting's [tumblr_client gem](https://github.com/codingjester/tumblr_client) for easy communication with the Tumblr v2 API.

A full tutorial for putting this whole app together (once it's finished) will be posted on [http://moncefbelyamani.com](http://moncefbelyamani.com).

## Contributing

Feel free to fork this project and submit enhancements, code improvements, and UI love.

## License

Copyright (c) 2012 Moncef Belyamani

This source code is released under an MIT license.