source 'http://rubygems.org'

gem 'rails', '3.1.0' # Railsy

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2', '0.3.11'
gem 'pg',     '0.13.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   "~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'authlogic',           '3.1.0'              # System autoryzacji i logowania
gem 'execjs',              '1.3.2'              # Uruchamia JS w Rubym
gem 'jquery-rails',        '1.0.19'             # Wsparcie dla JQuery w Railsach
gem 'kaminari',            '0.13.0'             # Stronnicowanie indeksów
gem 'nested_form',         '0.2.0'              # Formularze dla zagnieżdżonych modeli
gem 'therubyracer',        '0.10.1'             # Interpreter V8 JS w Rubym
gem 'acts-as-taggable-on', '~> 2.2.2'           # Tagowanie
gem 'rbbcode',             '0.1.11'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

gem 'adapter_extensions'                        # Wymagane przez ActiveWarehouse
gem 'fastercsv'                                 # Wymagane przez ActiveWarehouse
gem 'activewarehouse-etl', "~> 1.0.0.rc1"

group :development, :test do
  gem "annotate", "~> 2.4.1beta1"               # Automatycznie opisuje pola bazy danych w modelach
  gem 'autotest', '4.4.6'                       # Testy ednostkowe (używany przez RSpeca)
  gem 'faker', '1.0.1'                          # Pomaga generować obiekty
  gem 'populator', '1.0.0'                      # Populuje bazę danych
  gem 'rspec', '2.10.0'                         # Testy jednostkowe
  gem "rspec-rails", "~> 2.4"                   # Wsparcie dla RSpeca w Railsach
  gem 'linecache19', :git => 'git://github.com/mark-moseley/linecache'
  gem 'ruby-debug-base19x', '~> 0.11.30.pre4'
  gem 'ruby-debug19', :require => 'ruby-debug'  # Tryb debugowania w Rubym
  gem 'spork', '~> 0.9.0rc'                     # Preloaduje aplikację, aby można było np. wykonać testy bez przeładowywania całego systemu.
  gem 'turn', :require => false                 # Wyświetla wyniki testów jednostkowych
  gem 'webrat', '0.7.3'                         # Pomocny przy testach routingu i kontrolerów
  gem 'webrat-rspec-rails', '0.1.1'             # Wsparcie Webrata dla Railsów
end