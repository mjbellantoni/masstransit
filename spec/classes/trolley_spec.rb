require "spec_helper"
require "classes/trolley"


describe Trolley, "when created" do

  before(:each) do
    setup_chingu
    @trolley = Trolley.new
  end

  it "is stopped" do
    @trolley.should be_stopped
  end

end


describe Trolley do

  before(:each) do
    setup_chingu
    @trolley = Trolley.new
  end

  it "can move forward" do
    @trolley.forward
  end

  it "can be stopped" do
    @trolley.stop
  end

  context "that is stopped" do

    before(:each) do
      @trolley.stop
    end

    it "is stopped" do
      @trolley.should be_stopped
    end

    it "is not running" do
      @trolley.should_not be_running
    end

    it "has a velocity of 0.0 m/s" do
      @trolley.v.should be_within(0.001).of(0.0)
    end

  end

  context "that is moving forward" do

    before(:each) do
      @trolley.forward
    end

    it "is not stopped" do
      @trolley.should be_running
    end

    it "is running" do
      @trolley.should be_running
    end

    it "has a velocity of 4.470 m/s" do
      @trolley.v.should be_within(0.001).of(4.470)
    end

  end



end