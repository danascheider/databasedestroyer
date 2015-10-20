When(/^the client sends a DELETE request to '([^'])*'$/) do |path|
  delete path
end

Then(/^the test database should contain only the seed data$/) do 
  # The database contains the following tables:
  # users
  # task_lists
  # tasks
  # fachs
  # organizations
  step 'the users should be those from the seed data'
  # step 'the task lists should be those from the seed data'
  # step 'the tasks should be those from the seed data'
  # step 'the fachs should be those from the seed data'
  step 'the organizations should be those from the seed data'
end

Then(/^the users should be those from the seed data$/) do  
  users = $client.query('SELECT * FROM users').to_a.map(&:to_h)

  users.each do |user|
    expect($seeds['users']).to include(user.standardize(*$seeds['users'].first.keys))
  end
end

Then(/^the task lists should be those from the seed data$/) do 
  task_lists = $client.query('SELECT * FROM task_lists').to_a.map(&:to_h)

  task_lists.each do |list|
    expect($seeds['task_lists']).to include(list.standardize($seeds['task_lists'].first.keys))
  end
end

Then(/^the tasks should be those from the seed data$/) do 
  tasks = $client.query('SELECT * FROM tasks').to_a.map(&:to_h)

  tasks.each do |task|
    expect($seeds['tasks']).to include(task.standardize($seeds['tasks'].first.keys))
  end
end

Then(/^the fachs should be those from the seed data$/) do 
  fachs = $client.query('SELECT * FROM fachs').to_a.map(&:to_h)

  fachs.each do |fach|
    expect($seeds['fachs']).to include(fach.standardize($seeds['fachs'].first.keys))
  end
end

Then(/^the organizations should be those from the seed data$/) do 
  orgs = $client.query('SELECT * FROM organizations').to_a.map(&:to_h)
  
  orgs.each do |org|
    expect($seeds['organizations']).to include(org.standardize($seeds['organizations'].first.keys))
  end
end