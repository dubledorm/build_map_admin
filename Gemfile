source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.0.6', '>= 6.0.6.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :test do
  gem 'autotest'
  gem 'autotest-notification'
  gem 'autotest-rails-pure'
  gem 'capybara', '~> 2.18'
  gem 'database_cleaner'
  gem 'factory_girl_rails' , '~> 1.7.0'
  gem 'launchy'
  gem 'mocha', :require => false
  gem 'ruby-prof'
  gem 'test-unit'
  gem 'webmock'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end


group :development, :test do
  # Call 'bye_bug.rb' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'pry', '~>0.14'
  gem 'pry-byebug', '~>3.10'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.0.rc1'
  # Call 'bye_bug.rb' anywhere in the code to stop execution and get a debugger console
  gem 'dotenv-rails'
  gem 'rack_session_access'
  gem 'selenium-webdriver'
  gem 'shoulda', '~> 4.0'
  gem 'shoulda-context', '~> 2.0'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'timecop'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  #  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'spring', '~> 4.0'
  gem 'spring-watcher-listen', '~> 2.1'
end

gem 'activeadmin'
gem 'awesome_print'
gem 'devise'
gem 'draper'
gem 'haml'
gem 'has_scope'

# TODO: удалить при переходе на ruby 3
gem 'net-http'

gem 'rubyXL'


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
