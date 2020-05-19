# FiSeo

This gem provides a easier solution to search engine optimization(SEO) in a ruby project. This will give you the seo capabilities to your static pages and dynamic pages alike with few lines of code.
Also site maps are essential to the SEO of your web application. So this gem gives that capabilities with a feature to integrate google analytics.

This gem currently integrate with the Active Admin for management of the gem. Dynamic pages and other settings also include with the integration.


## Goals

1. To give ability to easily integrate seo solution with your application.
2. Give most popular seo strategies in a compact package.
3. To reduce the development time by substantial amount. 

## Dependencies

This gem depend on:
* activerecord
* meta-tags
* xml-sitemap

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fi_seo'
```

And then execute:

    $ bundle install
    
After updating your bundle, run the migration as follows:

    $ acts_as_seoable:migrate
    $ rails db:migrate
    
## Usage

First, add this code to your main layout:

```erb
# application.html.erb

<head>
  <%= display_meta_tags site: 'My website' %>
</head>
```

### Static Pages

For static pages you need to configure routes as follows:
```ruby
# routes.rb

root 'pages#home', defaults: { acts_as_seoable: true }
```

In routes you need to add defaults arguments to a static page.
You also can set act_as_seoable to false as well. But any other value used will also be considered as a false hence will not be a seoable route.

If you ran the server after this you would not see any different. Because we need to render the meta tags to the page. See following example for that:
```ruby
# some_controller.rb

def home
  set_meta_tags FiSeo.create_static_meta_tags(controller_name, action_name, social:%i[facebook twitter])
end
```

If the few action in a same controller with static pages use this instead:

```ruby
# application_controller.rb

def static_meta_tag_creation
  set_meta_tags FiSeo.create_static_meta_tags(controller_name, action_name)
end

# any_controller

before_action :static_meta_tag_creation
```

Note:  You can use any method name for before action method

### Dynamic Pages

For dynamic seoable pages you need to configure model as follows:
```ruby
# model.rb

acts_as_seoable :title, :description, :keywords
```
    
If the model has attributes for that you need to use for the seoable attributes you can add as above. You can also build and set by method as well.
```ruby
# model.rb  
 
acts_as_seoable :title_seoable, :description, :keywords

def title_seoable
"#{self.name}#{self.id}"
end
```  
 when you create a new record from this model the gem will create a corresponding seoable record as well. Above values will be set as default values.
 
 #### Options
 
 For dynamic records you can have option set for the model. Those options as follows:
      
| Option         | Description |
| -------------- | ----------- |
| `:separator`   | text used to separate website name from page title |
| `:lowercase`   | when true, the page name will be lowercase |
| `:reverse`     | when true, the page and site names will be reversed |
| `:noindex`     | add noindex meta tag; when true, 'robots' will be used; accepts a string with a robot name, or an array of strings |
| `:index`       | add index meta tag; when true, 'robots' will be used; accepts a string with a robot name, or an array of strings |
| `:nofollow`    | add nofollow meta tag; when true, 'robots' will be used; accepts a string with a robot name, or an array of strings |
| `:follow`      | add follow meta tag; when true, 'robots' will be used; accepts a string with a robot name, or an array of strings |
| `:noarchive`   | add noarchive meta tag; when true, 'robots' will be used; accepts a string with a robot name, or an array of strings |
| `:canonical`   | add canonical link tag |

And here are a few examples to give you ideas.

```ruby
# model.rb

acts_as_seoable :title, :description, :keywords, social: [:facebook, :twitter], noindex: true
```  

For social tags default they are empty. It can be set by the model as follows:

```ruby
# model.rb

def facebook_tags
  {
    title: 'title',
    type: 'type',
    url: 'url',
    image: 'image_url',
    description: 'description'
  }
end

def twitter_tags
  {
    title: 'title',
    card: 'card',
    site: 'site_url',
    image: 'image_url',
    description: 'description'
  }
end
```

### Sitemap

For sitemap you need to configure as follows:
```ruby
# routes.rb

root 'pages#home', defaults: { sitemap: true, static: true }
```
For static pages in the sitemap you must user static as true in the route. Otherwise this route will considered as dynamic route.

After that restart you server and you will able to see your sitemap at the path of:
    
    your_address/sitemap.xml

### Google Analytics

First, add this code to your main layout:

```erb
# application.html.erb

<head>
 <%= render 'google_analytics/acts_as_seoable' %>
</head>
```

Then you can edit the analytic Id from the backend.

### Generators

There are few initializers and generators for this gem to help you to configure the behavior of the gem.
#### Migration

Before using the gem you need to migrate the tables for gem to databalse. To get the migration run the following code:
```bash
$ acts_as_seoable:migrate
```
#### Gem Initializer
This initializer will give ability to set few social configuration and website name for seo and few other things.
Run the following code for to create initializer:
```bash
$ acts_as_seoable:install
```
#### Active Admin Page
*Only if you are using active admin*

To add SEO data to active admin you need to run following code. This will generate a admin page:
```bash
$ acts_as_seoable:admin
```

#### Active Admin View Helper
*Only if you are using active admin*

To add active admin view helper you need to run following code. This will generate a **arb** file to add dynamic pages show and edit action:
```bash
$ acts_as_seoable:admin_view_helper
```

### Active Admin

This gem is fully compatible with the active admin gem. To use run generator command to get a active admin page for all of data this gem has to offer.
Then you can configure it to your likings.

Special feature of this is you are able to add dynamic records that are **seoable** can be edited of viewed. For example if a model seoable configured
you can add to following code view data in active admin.

```erbruby
# app/admin/user.rb

show do |user|
  render partial: 'acts_as_seoable/view_helper', locals: { seoable: user, action: 'show' }
end
```  

You must add action and seoable variables as locals to work. action can has either **show** or **edit** variables.

To edit seo variables from active admin first you need to allow params to permit by the active admin. Then you can edit view helper to edit values.

```erbruby
# app/admin/user.rb

permit_params: dynamic_seos: [:title, :description, :keywords]
``` 
Then: 
```erbruby
# app/admin/user.rb

form do |f|
  if f.object.dynamic_seo.present?
    render partial: 'acts_as_seoable/view_helper', locals: { seoable: f, action: 'edit '}
  end
end
```

## ToDo Features


##Getting Help

Got a bug and you're not sure? You're sure you have a bug, but don't know what to do next? In any case, let us know about it! The best place for letting the Contributes know about bugs or problems you're having is on the page at GitHub.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fi_seo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/fi_seo/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FiSeo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fi_seo/blob/master/CODE_OF_CONDUCT.md).
