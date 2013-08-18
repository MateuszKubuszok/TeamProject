TeamProject
====

Project of a simple webpage for bug and issue tracking in RoR.

Prerequisites
----

Page requires Ruby 1.9.3 installed as well as components needed to run required libraries:
libraries for MySQL2 and PostgreSQL. On Debian those libraries can be installed with
`sudo apt-get install libmysqlclient-dev libpq-dev`.

Ruby itself can be installed via rvm. Gems used by project can be installed with bundler:
call `bundle install` from root directory of a checke out project. If bundler is not available
install it with `gem install bundle`.

Installation
----

Because TeamProject comes with ability to export data for TeamProject WareHouse project it
declares some additional databases in PostgreSQL that need to be created manually:

 * tp_wh,
 * tp_test_wh,
 * tp_dev_wh,

as well as one database created in MySQL: 

 * tp_etl.

Those settings can always be changed.

It also assumes that there are users `root` and `postgres` for MySQL2 and PostgreSQL respectively,
both of which uses `pass` as a password - this can (and should) be changed in `db/database.yml` file.

Once databases are set up You can install them with following commands run from project's root directory:

 * `rake db:createa`
 * `rake db:migrate`
 * `rake db:seed` - optionally for populating DB with data.
 
Starting up server
----

Server can be started up with `rails s` command run in a project's root.

Default admin account created with db:seed uses `root` and `pass` credentials.

Working with TeamProject WareHouse
----

For running Extract-Transform-Load process run `etl ./etl/process_all.efb` from root directory.

Reports can be viewed with TeamProject WareHouse webpage.

