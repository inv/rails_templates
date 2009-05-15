
 
 
##############  commands #################
 
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js > public/javascripts/jquery.js"
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
run "rm public/favicon.ico"
run "rm public/robots.txt"



plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git'
plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git'
plugin 'exception_notifier', :git => 'git://github.com/rails/exception_notification.git'
plugin 'asset_packager', :git => 'http://synthesis.sbecker.net/pages/asset_packager'
plugin 'make_resourceful', :git => 'git://github.com/hcatlin/make_resourceful.git'
plugin 'cucumber', :git => 'git://github.com/aslakhellesoy/cucumber.git' 
plugin 'webrat', :git => 'git://github.com/brynary/webrat.git'
plugin 'haml', :git => "git://github.com/nex3/haml.git"
plugin 'paperclip', :git => "git://github.com/thoughtbot/paperclip.git"
plugin 'make_resourceful', :git => "git://github.com/hcatlin/make_resourceful.git"

gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate',  :source => 'http://gems.github.com'
gem 'rubyist-aasm', :lib => 'aasm'
gem 'ruby-openid', :lib => 'openid'
gem 'thoughtbot-clearance', :lib => 'clearance', :source => 'http://gems.github.com', :version => '0.6.4'

rake("gems:install", :sudo => true)
rake("gems:unpack")

generate("rspec")
generate('features')
generate('clearance')

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

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

