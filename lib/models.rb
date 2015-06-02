class User < Sequel::Model
  has_many :task_lists
end

class TaskList < Sequel::Model 
  has_one :user
  has_many :tasks
end

class Task < Sequel::Model
  has_one :task_list
end