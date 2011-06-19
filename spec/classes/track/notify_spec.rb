require "spec_helper"
require "classes/track"
require "classes/trolley"


describe "A line of track from (0,0) to (0, 12)" do

  before(:each) do
    setup_chingu

    @track1 = Track.new(:a_x => 0, :a_y => 0, :b_x => 0, :b_y => 4)
    @track2 = @track1.t_b.extend_to(0, 8)
    @track3 = @track2.t_b.extend_to(0, 12)

    @trolley = Fabricate(:trolley)

    @observer = stub('observer')
    @observer.stub(:update) # Quiet error from observable library

    [@track1, @track2, @track3].each do |track|
      track.t_a.add_observer(@observer)
      track.t_b.add_observer(@observer)
    end

  end

  context "when added to (0,0)" do
    
    before(:each) do
      @observer.should_receive(:update).with(:enter, @trolley).ordered      
    end

    it "notifies observers when a trolley is added" do
      @track1.t_a.carry(@trolley)
    end

  end

  context "when travelling from (0, 0) to (0, 4.470)" do

    before(:each) do
      @observer.should_receive(:update).with(:enter, @trolley).ordered
      @observer.should_receive(:update).with(:exit, @trolley).ordered
      @observer.should_receive(:update).with(:enter, @trolley).ordered
    end

    it "notifies observers that the trolley has travelled" do
      @track1.t_a.carry(@trolley)
      @trolley.forward
      @trolley.update
    end

  end

  context "when travelling from (0, 0) to (0, 8.940)" do

    before(:each) do
      @observer.should_receive(:update).with(:enter, @trolley).ordered
      @observer.should_receive(:update).with(:exit, @trolley).ordered
      @observer.should_receive(:update).with(:enter, @trolley).ordered
      @observer.should_receive(:update).with(:exit, @trolley).ordered
      @observer.should_receive(:update).with(:enter, @trolley).ordered
    end

    it "notifies observers that the trolley has travelled" do
      @track1.t_a.carry(@trolley)
      @trolley.forward
      @trolley.update
      @trolley.update
    end

  end

  context "when added to (0,12)" do
    
    before(:each) do
      @observer.should_receive(:update).with(:enter, @trolley).ordered      
    end

    it "notifies observers when a trolley is added" do
      @track3.t_b.carry(@trolley)
    end

  end

  context "when travelling from (0, 12) to (0, 7.530)" do

    before(:each) do
      @observer.should_receive(:update).with(:enter, @trolley).ordered
      @observer.should_receive(:update).with(:exit, @trolley).ordered
      @observer.should_receive(:update).with(:enter, @trolley).ordered
    end

    it "notifies observers that the trolley has travelled" do
      @track3.t_b.carry(@trolley)
      @trolley.forward
      @trolley.update
    end

  end

  context "when travelling from (0, 12) to (0, 3.060)" do

    before(:each) do
      @observer.should_receive(:update).with(:enter, @trolley).ordered
      @observer.should_receive(:update).with(:exit, @trolley).ordered
      @observer.should_receive(:update).with(:enter, @trolley).ordered
      @observer.should_receive(:update).with(:exit, @trolley).ordered
      @observer.should_receive(:update).with(:enter, @trolley).ordered
    end

    it "notifies observers that the trolley has travelled" do
      @track3.t_b.carry(@trolley)
      @trolley.forward
      @trolley.update
      @trolley.update
    end

  end

end