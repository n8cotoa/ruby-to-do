
class Task
  attr_reader(:description, :list_id, :due_date)

  def initialize(attributes)
    @description = attributes.fetch(:description)
    @list_id = attributes.fetch(:list_id)
    @due_date = attributes.fetch(:due_date, Date.new(2018,7,9)).to_s
  end

  def self.all
    returned_tasks = DB.exec("SELECT * FROM tasks;")
    tasks = []
    returned_tasks.each() do |task|
      description = task.fetch("description")
      list_id = task.fetch("list_id").to_i()
      due_date = task.fetch("due_date")
      tasks.push(Task.new({:description => description, :list_id => list_id, :due_date => due_date}))
    end
    tasks
  end

  def ==(another_task)
    self.description().==(another_task.description()).&(self.list_id().==(another_task.list_id())).&(self.due_date().==(another_task.due_date()))
  end

  def save
    DB.exec("INSERT INTO tasks (description, list_id, due_date) VALUES ('#{@description}', #{@list_id}, '#{@due_date}');")
  end

  def self.sort
    sorted_list = []
    sorted = DB.exec("SELECT * FROM tasks ORDER BY due_date;")
    sorted.each do |list|
      description = list.fetch("description")
      list_id = list.fetch("list_id").to_i()
      due_date = list.fetch("due_date")
      sorted_list.push(Task.new({:description => description, :list_id => list_id, :due_date => due_date}))
    end
    sorted_list
  end
end
