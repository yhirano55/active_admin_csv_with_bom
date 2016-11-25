rails_major_version = Rails::VERSION::STRING[0].to_i

# == Configure default_url_options in test environment
inject_into_file(
  "config/environments/test.rb",
  "  config.action_mailer.default_url_options = { :host => 'example.com' }\n",
  after: "config.cache_classes = true\n"
)

# == Add our local Active Admin to the load path
inject_into_file(
  "config/environment.rb",
  "\n$LOAD_PATH.unshift('#{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))}')\nrequire \"active_admin\"\n",
  after: rails_major_version >= 5 ? "require_relative 'application'" : "require File.expand_path('../application', __FILE__)"
)

run "rm Gemfile"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

# == Prepare Model
generate :model, "Post title:string content:text"

# == Prepare ActiveAdmin
generate :'active_admin:install --skip-users'
generate :'active_admin:resource Post'

run "rm -r spec"

route "root :to => 'admin/dashboard#index'"

rake "db:migrate"
