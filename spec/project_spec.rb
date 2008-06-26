require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe Todoist::Project do
  describe "initializes from a parsed JSON hash" do
    before(:each) do
      @results_hash = JSON.parse %Q/{"user_id": 1, "name": "Test project", "color": 1, "collapsed": 0, "item_order": 1, "indent": 1, "cache_count": 4, "id": 22073}/
      @project = Todoist::Project.new_from_hash(@results_hash)
    end

    it "should be a project" do
      @project.should be_an_instance_of(Todoist::Project)
    end
    it "should have the correct name assigned from the hash" do
      @project.name.should == @results_hash['name']
    end
    it "should have the correct user id assigned from the hash" do
      @project.user_id.should_not be_nil
      @project.user_id.should == @results_hash['user_id']
    end
    it "should have the correct project id assigned" do
      @project.id.should_not be_nil
      @project.id.should == @results_hash['id']
    end
    it "should have the correct order assigned" do
      @project.order.should_not be_nil
      @project.order.should == @results_hash['item_order']
    end
    it "should have the correct task count assigned" do
      @project.task_count.should_not be_nil
      @project.task_count.should == @results_hash['cache_count']
    end
  end
  describe "has a sensible == method" do
    it "shouldn't equal a string" do
      Todoist::Project.new('test').should_not == 'test'
    end
    it "should equal a project with the same name if id is nil" do
      Todoist::Project.new('test').should == Todoist::Project.new('test')
    end
    it "shouldn't equal a project with the same name if id isn't nil" do
      Todoist::Project.new('test', 10).should_not == Todoist::Project.new('test',11)
    end
    it "should equal a project with the same name if the ids are the same" do
      Todoist::Project.new('test', 10).should == Todoist::Project.new('test',10)
    end
    it "should equal a project with a different name if the ids are the same" do
      Todoist::Project.new('test', 10).should == Todoist::Project.new('test2',10)
    end
  end
  describe "#all" do
    it "should retrive projects" do
      # we have to query via getProjects
      Todoist::Connection.should_receive(:api_request).with("getProjects").and_return([:one, :two, :three])

      # we want to create three new projects from the three 'hashes' we have
      Todoist::Project.should_receive(:new_from_hash).exactly(3).times.and_return(:a, :b, :c)

      # we should return an array of completed projects
      Todoist::Project.all.should == [:a, :b, :c]
    end
  end
  describe "#get" do
    it "should retrive a project of a given id via get" do
      # we have to query via getProject
      Todoist::Connection.should_receive(:api_request).with("getProject", 'id' => 1).and_return(:one)

      # we want to create a new project from the JSON
      Todoist::Project.should_receive(:new_from_hash).exactly(1).times.and_return(:a)

      Todoist::Project.get(1).should == :a
    end
    it "shouldn't raise on a bad id asked for in get" do
      # we have to query via getProject which should have returned 500, so it raises
      Todoist::Connection.should_receive(:api_request).with("getProject", 'id' => 2).and_raise(Todoist::BadResponse)

      lambda { Todoist::Project.get(2) }.should_not raise_error
    end
    it "should return nil on non-existent id" do
      Todoist::Connection.should_receive(:api_request).with("getProject", 'id' => 2).and_raise(Todoist::BadResponse)

      Todoist::Project.get(2).should be_nil
    end
    it "should raise on a random other error" do
      Todoist::Connection.should_receive(:api_request).with("getProject", 'id' => 2).and_raise(Exception)
      lambda { Todoist::Project.get(2) }.should raise_error
    end
  end
  describe "#get!" do
    it "should retrive a project of a given id via get" do
      # we have to query via getProject
      Todoist::Connection.should_receive(:api_request).with("getProject", 'id' => 1).and_return(:one)

      # we want to create a new project from the JSON
      Todoist::Project.should_receive(:new_from_hash).exactly(1).times.and_return(:a)

      Todoist::Project.get!(1).should == :a
    end
    it "raise on a bad id asked for in get" do
      # we have to query via getProject which should have returned 500, so it raises
      Todoist::Connection.should_receive(:api_request).with("getProject", 'id' => 2).and_raise(Todoist::BadResponse)

      lambda { Todoist::Project.get!(2) }.should raise_error(Todoist::BadResponse)
    end
  end
end
