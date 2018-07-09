require 'rspec'
require 'pg'
require 'task'
require("spec_helper")
require 'pry'

DB = PG.connect({:dbname => 'to_do_testing'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM tasks *;")
  end
end

describe(Task) do
  describe(".all") do
    it("is empty at first") do
      expect(Task.all()).to(eq([]))
    end
  end

  describe("#save") do
    it("adds a task to the array of saved tasks") do
      test_task = Task.new({:description => "learn SQL", :list_id => 1})
      test_task.save()
      expect(Task.all()).to(eq([test_task]))
    end
  end

  describe("#description") do
    it("lets you read the description out") do
      test_task = Task.new({:description => "learn SQL", :list_id => 1})
      expect(test_task.description()).to(eq("learn SQL"))
    end
  end

  describe("#list_id") do
    it("lets you read the list ID out") do
      test_task = Task.new({:description => "learn SQL", :list_id => 1})
      expect(test_task.list_id()).to(eq(1))
    end
  end

  describe("#==") do
    it("is the same task if it has the same description and list ID") do
      task1 = Task.new({:description => "learn SQL", :list_id => 1})
      task2 = Task.new({:description => "learn SQL", :list_id => 1})
      expect(task1).to(eq(task2))
    end
  end

  describe(".sort") do
    it("sort tasks by due date") do
      task1 = Task.new({:description => "Learn SQL", :list_id => 1, :due_date => Date.new(2018, 7, 25)})
      task1.save()
      task2 = Task.new({:description => "Learn Ruby", :list_id => 2, :due_date => Date.new(2018, 7, 13)})
      task2.save()
      task3 = Task.new({:description => "Learn Java", :list_id => 3, :due_date => Date.new(2018, 7, 29)})
      task3.save()
      Task.sort()
      expect(Task.sort()).to(eq([task2, task1,task3]))
    end
  end
end
