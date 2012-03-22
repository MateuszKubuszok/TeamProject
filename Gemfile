source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
group :production do
  gem 'pg'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'authlogic'                                 # System autoryzacji i logowania
gem 'execjs'                                    # Uruchamia JS w Rubym
gem 'jquery-rails'                              # Wsparcie dla JQuery w Railsach
gem 'kaminari'                                  # Stronnicowanie indeksów
gem 'nested_form'                               # Formularze dla zagnieżdżonych modeli
gem 'therubyracer'                              # Interpreter V8 JS w Rubym
gem 'acts-as-taggable-on', '~> 2.2.2'           # Tagowanie

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :development, :test do
  gem "annotate", "~> 2.4.1beta1"               # Automatycznie opsiuje pola bazy danych w modelach
  gem 'autotest'                                # Testy ednostkowe (używany przez RSpeca)
  gem 'rspec'                                   # Testy jednostkowe
  gem "rspec-rails", "~> 2.4"                   # Wsparcie dla RSpeca w Railsach
  gem 'ruby-debug19', :require => 'ruby-debug'  # Tryb debugowania w Rubym
  gem 'spork', '~> 0.9.0rc'                     # Preloaduje aplikację, aby można było np. wykonać testy bez przeładowywania całego systemu.
  gem 'turn', :require => false                 # Wyświetla wyniki testów jednostkowych
  gem 'webrat'                                  # Pomocny przy testach routingu i kontrolerów
  gem 'webrat-rspec-rails'                      # Wsparcie Webrata dla Railsów
end