# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# użytkownicy

require 'faker'
require 'populator'


# Czyczczenie bazy danych
puts "\n"+'Clearing current DB'
[
  Article,
  ArticleComment,
  Bug,
  Forum,
  ForumThread,
  Milestone,
  Project,
  Response,
  TeamInvitation,
  Ticket,
  User,
  UserConfiguration,
  UserForumRelationship,
  UserProjectRelationship
].each(&:delete_all)
puts 'Success!'


# Tworzenie konta roota
puts "\n"+'Creating root account'
User.new({
  'login'                 => 'root',
  'url_name'              => 'root',
  'password'              => 'pass',
  'password_confirmation' => 'pass',
  'email'                 => 'root@email.net',
  'www'                   => 'www.google.pl',
  'privileges'            => (2**(User.symbols_quantity :privilege_types)-1) # allow user to access privileges
}).save!
puts 'Success!'


# Populuje tablicę użytkowników
puts "\n"+'Populating Users'
User.populate 30 do |user|
  user.login                  = Faker::Internet.user_name
  user.name                   = Faker::Name.first_name
  user.surname                = Faker::Name.last_name
  user.about_me               = Faker::Lorem.paragraphs
  user.email                  = Faker::Internet.free_email
  user.www                    = Faker::Internet.url

  url_name = user.login
  begin
    url_name['.'] = '_'
  rescue IndexError
    true
  end
  user.url_name = url_name

  salt = Authlogic::Random.hex_token
  user.password_salt       = salt
  user.crypted_password    = Authlogic::CryptoProviders::Sha512.encrypt('pass' + salt)
  user.persistence_token   = Authlogic::Random.friendly_token
  user.single_access_token = Authlogic::Random.friendly_token
  user.perishable_token    = Authlogic::Random.friendly_token
end
all_users = User.all
puts 'Success!'


# Populuje projekty/milestonsy/tickety
puts "\n"+'Populating projects'
Project.populate 50 do |project|
  project.name              = Faker::Company.bs
  project.short_description = Faker::Lorem.paragraph
  project.description       = Faker::Lorem.paragraphs
  project.private           = Random.rand(2)

  url_name = Faker::Internet.user_name
  begin
    url_name['.'] = '_'
  rescue IndexError
    true
  end
  project.url_name = url_name

  # Łączy projekt z jego członkami
  users = all_users
  members = []
  UserProjectRelationship.populate 10 do |upr|
    user    =  users.sample
    users   -= [user]
    members += [user]

    upr.project_id = project.id
    upr.user_id    = user.id
    upr.privileges = Random.rand(2**(UserProjectRelationship.symbols_quantity :privilege_types))
  end

  # Zaprasza ludzi do projektu
  TeamInvitation.populate 5 do |invitation|
    user    =  users.sample
    users   -= [user]

    invitation.project_id = project.id
    invitation.user_id    = user.id
  end

  # Generuje milestonesy
  Milestone.populate 10 do |milestone|
    milestone.project_id  = project.id
    milestone.name        = Faker::Company.bs
    milestone.description = Faker::Company.bs

    Ticket.populate 20 do |ticket|
      ticket.milestone_id = milestone.id
      ticket.user_id      = members.sample.id
      ticket.name         = Faker::Company.bs
      ticket.description  = Faker::Company.bs
      ticket.priority_id  = [-1,0,1].sample
      ticket.status_id    = Random.rand(Ticket.symbols_quantity :status_types)+1
      ticket.deadline     = (Random.rand(100)-200).days.ago
    end
  end
end
puts 'Success!'


# Populuje fora
puts "\n"+'Populating foras'
Forum.populate 5 do |forum|
  forum.name        = Faker::Company.bs
  forum.description = Faker::Lorem.paragraph

  Forum.populate 5 do |subforum|
    subforum.forum_id = forum.id
    subforum.name        = Faker::Company.bs
    subforum.description = Faker::Lorem.paragraph
  end
end
foras = Forum.all
puts 'Success!'


# Populuje wątki
puts "\n"+'Populating threads'
ForumThread.populate 50 do |thread|
  thread.forum_id   = foras.sample.id
  thread.title      = Faker::Company.bs
  thread.content    = Faker::Lorem.paragraphs
  thread.user_id    = all_users.sample.id
  thread.created_at = (Random.rand(100)-200).days.ago

  previous_time = thread.created_at
  Response.populate 5 do |response|
    response.forum_thread_id = thread.id
    response.title   = Faker::Company.bs
    response.content = Faker::Lorem.paragraphs
    response.user_id = all_users.sample.id
    response.created_at = Random.rand(24*60*60).seconds.since previous_time
    previous_time = response.created_at
  end
end
puts 'Success!'