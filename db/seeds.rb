# ustawienia dla bazy użytkowej
settings = {
  reset:    true,  # czy ma usunąć wszystko z bazy danych i wgrać na nowo
  populate: true,  # czy ma dodać nowe losowe alementy do bazy
  modify:   false  # czy ma zmodyfikować istniejące elementy
}

# ustawienia dla hurtowni danych
wh_settings = {
  reset:    false # czy ma usunąć wszystko z bazy danych i wgrać na nowo
}


# resetuje bazę danych
if settings[:reset]
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
end


# populuje tablice
if settings[:populate]
  require 'faker'
  require 'populator'


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
  puts "\n"+'Populating Projects'
  Project.populate 50 do |project|
    project.name              = Faker::Company.bs
    project.short_description = Faker::Lorem.paragraph
    project.description       = Faker::Lorem.paragraphs
    project.private           = Random.rand(2)
    project.views             = Random.rand(1000000)

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

    # Generuje bugi
    Bug.populate 10 do |bug|
      bug.project_id        = project.id
      bug.status_id         = Random.rand(Bug.symbols_quantity :status_types)+1
      bug.type_id           = Random.rand(Bug.symbols_quantity :type_types)+1
      bug.priority_id       = [-1,0,1].sample
      bug.short_description = Faker::Lorem.paragraph
      bug.description       = Faker::Lorem.paragraphs
      bug.commentary        = Faker::Lorem.paragraphs
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
  puts "\n"+'Populating Forums'
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
  puts "\n"+'Populating Threads'
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
end


# modyfikuje istniejącą baze danych
if settings[:modify]
ActiveRecord::Base.transaction do
  # aktualizuje wyświetlenia strony
  puts "\n"+'Updating Projects'
  Project.all.each do |project|
    project.views += Random.rand 10000
    project.save!
  end
  puts 'Success!'

  # aktualizuje statusy
  puts "\n"+'Updating Tickets'
  Ticket.all.each do |ticket|
    ticket.status_id += Random.rand(Ticket.symbols_quantity(:status_types)-ticket.status_id+1)
    ticket.save!
  end
  puts 'Success!'

  # aktualizuje statusy
  puts "\n"+'Updating Bugs'
  Bug.all.each do |bug|
    bug.status_id += Random.rand(Bug.symbols_quantity(:status_types)-bug.status_id+1)
    bug.save!
  end
  puts 'Success!'
end
end


if wh_settings[:reset]
  # Czyczczenie hurtowni danych
  puts "\n"+'Clearing current WH'
  [
    BugDimension,
    BugFact,
    PmtDimension,
    ProjectFact,
    TicketFact,
    UserDimension
  ].each(&:delete_all)
  puts 'Success!'
end
