require('rspec')
require('pg')
require('list')
require('task')
require("spec_helper")

DB = PG.connect({:dbname => 'to_do_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM lists *;")
  end
end

describe(List) do
  describe(".all") do
    it("starts off with no lists") do
      expect(List.all()).to(eq([]))
    end
  end

  describe("#name") do
    it("tells you its name") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      expect(list.name()).to(eq("Epicodus stuff"))
    end
  end

  describe("#id") do
    it("sets its ID when you save it") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      list.save()
      expect(list.id()).to(be_an_instance_of(Integer))
    end
  end

  describe("#save") do
    it("lets you save lists to the database") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      list.save()
      expect(List.all()).to(eq([list]))
    end
  end

  describe("#==") do
    it("is the same list if it has the same name") do
      list1 = List.new({:name => "Epicodus stuff", :id => nil})
      list2 = List.new({:name => "Epicodus stuff", :id => nil})
      expect(list1).to(eq(list2))
    end
  end

  describe("#sort_task") do
    it("sort tasks into correct lists") do
      test_list = List.new({:name => "Epicodus Stuff", :id => nil})
      test_list.save()
      task1 = Task.new({:description => "Learn SQL", :list_id => test_list.id, :due_date => Date.new(2018, 7, 25)})
      task1.save()
      task2 = Task.new({:description => "Learn Ruby", :list_id => 2, :due_date => Date.new(2018, 7, 13)})
      task2.save()
      task3 = Task.new({:description => "Learn Java", :list_id => test_list.id, :due_date => Date.new(2018, 7, 29)})
      task3.save()
      expect(test_list.sort_task).to(eq([task1, task3]))
    end
  end
end
