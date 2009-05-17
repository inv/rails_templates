# InVisible Twitter App Generator
# based on the one by Michael Bleigh
# http://github.com/mbleigh/rails-templates/raw/master/twitterapp.rb

#
# Build the complete skeleton for a Twitter application using
# TwitterAuth. This generator will automatically build the
# basics for an OAuth-based Twitter application and will prompt
# you for your OAuth credentials.

app_name = ask("\nWhat is your application called?")

puts "\nBefore this generator runs you will need to register two Twitter applications for OAuth at http://twitter.com/apps. One will be for development (enter the callback as http://localhost.com:3000/oauth_callback) and the other for production (enter your production URL and callback).

Once finished, enter the consumer keys and secrets when prompted below:\n"

dev_consumer_key = ask("\nDevelopment OAuth Consumer Key:")
dev_consumer_secret = ask("\nDevelopment OAuth Consumer Secret:")
prod_consumer_key = ask("\nProduction OAuth Consumer Key:")
prod_consumer_secret = ask("\nProduction OAuth Consumer Secret:")


run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-ENDEND
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
ENDEND
run "rm README"
run "rm public/index.html"
run 'rm public/images/rails.png'
run "rm public/favicon.ico"
run "rm public/robots.txt"

git :init
git :add => "."
git :commit => '-m "Initial commit."'


plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git'
plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git'
plugin 'exception_notifier', :git => 'git://github.com/rails/exception_notification.git'
plugin 'cucumber', :git => 'git://github.com/aslakhellesoy/cucumber.git' 
plugin 'webrat', :git => 'git://github.com/brynary/webrat.git'
plugin 'haml', :git => "git://github.com/nex3/haml.git"
plugin 'paperclip', :git => "git://github.com/thoughtbot/paperclip.git"
plugin 'make_resourceful', :git => "git://github.com/hcatlin/make_resourceful.git"
plugin 'jrails', :git => 'git://github.com/aaronchi/jrails.git '
plugin 'uberkit', :git => 'git://github.com/mbleigh/uberkit.git'
plugin 'machinist', :git => 'git://github.com/technoweenie/machinist.git'


gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate',  :source => 'http://gems.github.com'
gem 'rubyist-aasm', :lib => 'aasm'
gem 'ruby-openid', :lib => 'openid'
gem 'oauth', :version => '>= 0.3.1'
gem 'twitter-auth', :lib => 'twitter_auth'
gem 'faker', :version => '~>0.3'


run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"
inside ('public/javascripts') do
  run "rm prototype.js"
  run "rm controls.js"
  run "rm effects.js"
  run "rm dragdrop.js"  
end

inside ('') do
  run 'capify .'
end
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-CODE
log/*.log
tmp/**/*
.DS_Store
doc/api
doc/app
coverage
db/*.sqlite3
db/development_structure.sql
db/schema.rb
public/avatars
public/uploads      
public/system/uploads/*
index/*
tmp/*
*.swp
CODE

file 'log/.gitignore', <<CODE
*.log
CODE

file 'tmp/.gitignore', <<CODE
*
CODE
generate("rspec")
generate('cucumber')
generate('twitter_auth')
generate('controller', 'static')

file 'app/views/layouts/master.html.haml', <<-TEMPLATE
!!!
%html
  %head
    %meta{ :"http-equiv" => "Content-type", :content => "text/html; charset=utf-8" }
    %title
      #{app_name} 
      |
      = @title || "Powered by TwitterAuth" 
      
    = stylesheet_link_tag 'master' 
    = javascript_include_tag 'jquery.js'
    = javascript_include_tag 'application.js'
  %body
    #wrapper
      #header
        #h1= link_to '#{app_name}', '/' 
         
        #user_bar
          - if logged_in? 
            = image_tag(current_user.profile_image_url, :width => 24, :height => 24)
            Logged in as 
            %strong
              = current_user.login 
            
            = link_to 'Log out', '/logout'
          - else
            = link_to 'Login via Twitter', '/login' 
          
        .clearfix
    
      #contents
        - if flash[:error] 
          .flash.error
            = flash[:error]
        - if flash[:notice] 
          .flash.notice
            = flash[:notice]
        
        = yield

    #footer
      Copyright &copy; 2009 #{app_name}

TEMPLATE

file 'app/views/static/index.html.haml', <<-TEMPLATE
%h2
  Welcome to Your Twitter Application!

%p
  You have successfully created a Twitter-ready application! 
  To test it out just click on 
  %strong 
    Login via Twitter
  above. You should be taken to Twitter and then back here where it will tell you that you are logged in!

%p
  This template doesn't assume anything about how you want to build your application other than that 
  you want to use Twitter authentication to do it, so you can generate any controllers, models, 
  and anything else you like! You can tie it back to Twitter accounts simply by adding associations etc. 
  to 
  %code
    app/models/user.rb

- if @users.any?
  %h2
    Recently Joined
  - for user in @users 
    = link_to profile_image(user), twitter_profile_url(user), :target => "_blank" 

TEMPLATE

file 'public/stylesheets/sass/master.sass', <<-SASS
body
  :font-family Arial, sans-serif
  :background #cef
  :margin 0
  :padding 0
  :color #333

a
  :color #06b
  :font-weight bold
  img
    :border 0

.clearfix
  :clear both

#wrapper
  :background white
  :padding 1.5em 2em
  :width 55em
  :-moz-border-radius 1em
  :-webkit-border-radius 1em
  :border-radius 1em
  :margin 1em auto 0.5em

#footer
  :text-align center
  :font-size 0.8em
  :color #666
  :padding-bottom 1.5em

#header
  h1
    :float left
    :font-size 3em
    :margin 0
    :padding 0
    a
      :color #057
      :text-decoration none
    :margin-bottom 0.3em
  #user_bar
    :float right
    :margin-top 1.2em
    img
      :vertical-align middle

p
  :line-height 150%

div.flash
  :padding 4px 8px
  :-moz-border-radius 4px
  :-webkit-border-radius 4px
  :border-radius 4px
  :border 2px solid #ccc
  :margin 10px 0

div.error
  :background #fcc
  :border-color #911
  :color #311

div.notice
  :background #cfc
  :border-color #191
  :color #131
SASS

file 'app/controllers/application_controller.rb', <<-RUBY
class ApplicationController < ActionController::Base
  layout 'master'
  helper :all
end
RUBY

file 'app/controllers/static_controller.rb', <<-RUBY
class StaticController < ApplicationController
  def index
    @users = User.all(:order => "created_at DESC", :limit => 16)
  end
end
RUBY

file 'app/helpers/twitter_helper.rb', <<-RUBY
module TwitterHelper
  def twitter_profile_url(user)
    "http://twitter.com/\#{user.login}"
  end

  def twitter_name(user)
    "@\#{user.login}"
  end

  def profile_image(user, options = {})
    alt = "\#{user.name} (@\#{user.login})"
    image_tag(user.profile_image_url, :alt => alt, :title => alt)
  end
end
RUBY

run "cp config/twitter_auth.yml config/twitter_auth.yml.example"

file 'config/twitter_auth.yml', <<-YAML
development:
  strategy: oauth
  oauth_consumer_key: "#{dev_consumer_key}"
  oauth_consumer_secret: "#{dev_consumer_secret}"
  base_url: "http://twitter.com"
  authorize_path: "/oauth/authenticate"
  api_timeout: 10
  remember_for: 14 # days
  oauth_callback: "http://localhost:3000/oauth_callback"
test:
  strategy: oauth
  oauth_consumer_key: "#{dev_consumer_key}"
  oauth_consumer_secret: "#{dev_consumer_secret}"
  authorize_path: "/oauth/authenticate"  
  base_url: "http://twitter.com"
  api_timeout: 10
  remember_for: 14 # days
  oauth_callback: "http://localhost:3000/oauth_callback"
production:
  strategy: oauth
  oauth_consumer_key: "#{prod_consumer_key}"
  oauth_consumer_secret: "#{prod_consumer_secret}"
  authorize_path: "/oauth/authenticate"  
  base_url: "http://twitter.com"
  api_timeout: 10
  remember_for: 14 # days
YAML

route "map.root :controller => 'static', :action => 'index'"
route "map.static '/:action', :controller => 'static'"

git :add => '.'
git :commit => '-m "Adding in templates, gems, and plugins."'





if yes?("\nRun rake gems:install? (yes/no)")
  rake("gems:install", :sudo => true)
  rake("gems:unpack")
end

if yes?("\nCreate and migrate databases now? (yes/no)")
  rake("db:create:all")
  rake("db:migrate")
end

git :commit => "-a -m 'Finished  commit'"

