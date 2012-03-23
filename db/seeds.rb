# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# użytkownicy

root = User.new({
  'login'                 => 'root',
  'url_name'              => 'root',
  'password'              => 'pass',
  'password_confirmation' => 'pass',
  'email'                 => 'root@email.net',
  'www'                   => 'www.google.pl',
  'privileges'            => (2**(User.symbols_quantity :privilege_types)-1).to_s # allow user to access privileges
})
root.save!

user = User.new({
  'login'                 => 'user',
  'url_name'              => 'user',
  'password'              => 'pass',
  'password_confirmation' => 'pass',
  'email'                 => 'user@email.net'
})
user.save!

tester = User.new({
  'login'                 => 'tester',
  'url_name'              => 'tester',
  'password'              => 'pass',
  'password_confirmation' => 'pass',
  'email'                 => 'tester@email.net'
})
tester.save!

# projekty

project = Project.new({
  'name'              => 'Test project',
  'url_name'          => 'test_project',
  'short_description' => 'A project for tests',
  'description'       => 'here we can have some description',
  'private'           => 1,
  'tags_list'         => 'some tag, some other tag'
})
project.save_for! user.id
project.users << tester

project2 = Project.new({
  'name'              => 'Test project 2',
  'url_name'          => 'test_project_2',
  'short_description' => 'Another project for tests',
  'description'       => 'here we can have some other description',
  'private'           => 0,
  'tags_list'         => 'nice tag, other nice tag'
})
project2.save_for! tester.id
project2.users << user

# zaproszenia

invitation = TeamInvitation.new({
  'user_id'     => root.id,
  'project_id'  => project.id
})
invitation.save!

invitation2 = TeamInvitation.new({
  'user_id'     => root.id,
  'project_id'  => project2.id
})
invitation2.save!

# fora

forum = Forum.new({
  'name'        => 'first forum',
  'description' => 'some description about forum',
  'tags_list'   => 'some tag'
})
forum.save!

subforum = Forum.new({
  'name'        => 'subforum',
  'description' => 'some subforum description',
  'forum_id'    => forum.id,
  'tags_list'   => 'nice tag'
})
subforum.save!

thread = ForumThread.new({
  'title'       => 'first thread',
  'content'     => 'first thread content',
  'forum_id'    => subforum.id,
  'user_id'     => root.id
})
thread.save!

response = Response.new({
  'title'   =>  'response to first',
  'content' =>  'response content',
  'forum_thread_id' =>
                thread.id,
  'user_id' =>  user.id
})
response.save!