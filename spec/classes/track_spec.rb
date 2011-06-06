require "spec_helper"
require "classes/track"
require "classes/trolley"


describe Track, "when created" do

  before(:each) do
    setup_chingu
    @track = Track.new(0, 0, 0, 10)
  end

  it "does not carry a trolley" do
    @track.trolley.should be_nil
  end

  it "has an unconnected A terminal" do
    @track.t_a.should_not be_connected
  end

  it "has an unconnected B terminal" do
    @track.t_b.should_not be_connected
  end

end



shared_examples_for "basic single track" do |a_x, a_y, b_x, b_y, ab, ba|

  context "from a = (#{a_x}, #{a_y}) to b = (#{b_x}, #{b_y})" do
    
    before(:each) do
      setup_chingu
      @track = Track.new(a_x, a_y, b_x, b_y)
      @trolley = Fabricate(:trolley)
    end

    context "when a trolley is added to terminal a" do

      before(:each) do
        @track.t_a.carry(@trolley)
      end

      it "tells the trolley it is at (#{a_x}, #{a_y})" do
        @trolley.x.should be_within(0.001).of(a_x)
        @trolley.y.should be_within(0.001).of(a_y)
      end

      context "when it moves forward" do

        before(:each) do
          @trolley.forward
        end

        context "after one step (one second)" do
          before(:each) do
            @track.update
          end

          it "tells the trolley it is at (#{ab[0]}, #{ab[1]})" do
            @trolley.x.should be_within(0.001).of(ab[0])
            @trolley.y.should be_within(0.001).of(ab[1])
          end
        end

        context "after two steps (two seconds)" do
          before(:each) do
            2.times { @track.update }
          end

          it "tells the trolley it is at (#{ab[2]}, #{ab[3]})" do
            @trolley.x.should be_within(0.001).of(ab[2])
            @trolley.y.should be_within(0.001).of(ab[3])
          end
        end

        context "after three steps (three seconds)" do
          before(:each) do
            2.times { @track.update }
          end

          it "the trolley is off the end of the track!" do
            lambda { @track.update }.should raise_error(OffTheRailsException, "The trolley ran off the end of the track!")
          end
        end

      end
    end

    context "when a trolley is added to terminal b" do

      before(:each) do
        @track.t_b.carry(@trolley)
      end

      it "tells the trolley it is at (#{b_x}, #{b_y})" do
        @trolley.x.should be_within(0.001).of(b_x)
        @trolley.y.should be_within(0.001).of(b_y)
      end

      context "when it moves forward" do

        before(:each) do
          @trolley.forward
        end

        context "after one step (one second)" do
          before(:each) do
            @track.update
          end

          it "tells the trolley it is at (#{ba[0]}, #{ba[1]})" do
            @trolley.x.should be_within(0.001).of(ba[0])
            @trolley.y.should be_within(0.001).of(ba[1])
          end
        end

        context "after two steps (two seconds)" do
          before(:each) do
            2.times { @track.update }
          end

          it "tells the trolley it is at (#{ba[2]}, #{ba[3]})" do
            @trolley.x.should be_within(0.001).of(ba[2])
            @trolley.y.should be_within(0.001).of(ba[3])
          end
        end

        context "after three steps (three seconds)" do
          before(:each) do
            2.times { @track.update }
          end

          it "the trolley is off the end of the track!" do
            lambda { @track.update }.should raise_error(OffTheRailsException, "The trolley ran off the end of the track!")
          end
        end

      end

    end


  end

end


describe Track do

  # Anchored at 0, 0 and out positively on one axis.
  it_behaves_like "basic single track",
    0, 0, 0, 10,                  # Endpoints
    [0.000, 4.470, 0.000, 8.940], # Expected A -> B traverse
    [0.000, 5.530, 0.000, 1.060]  # Expected B -> A traverse

  it_behaves_like "basic single track",
    0, 10, 0, 0,
    [0.000, 5.530, 0.000, 1.060],
    [0.000, 4.470, 0.000, 8.940]

  it_behaves_like "basic single track",
    0, 0, 10, 0,
    [4.470, 0.000, 8.940, 0.000],
    [5.530, 0.000, 1.060, 0.000]

  it_behaves_like "basic single track",
    10, 0, 0, 0,
    [5.530, 0.000, 1.060, 0.000],
    [4.470, 0.000, 8.940, 0.000]


  # Anchored at 0, 0 and out negatively on one axis.
  it_behaves_like "basic single track",
    0, 0, 0, -10,
    [0.000, -4.470, 0.000, -8.940],
    [0.000, -5.530, 0.000, -1.060]

  it_behaves_like "basic single track",
    0, -10, 0, 0,
    [0.000, -5.530, 0.000, -1.060],
    [0.000, -4.470, 0.000, -8.940]
    
  it_behaves_like "basic single track",
    0, 0, -10, 0,
    [-4.470, 0.000, -8.940, 0.000],
    [-5.530, 0.000, -1.060, 0.000]
  
  it_behaves_like "basic single track",
    -10, 0, 0, 0,
    [-5.530, 0.000, -1.060, 0.000],
    [-4.470, 0.000, -8.940, 0.000]


  # Anchored at 0,0 and out on two axis.
  it_behaves_like "basic single track",
    0, 0, 7.071, 7.071,
    [3.161, 3.161, 6.322, 6.322],
    [3.910, 3.910, 0.749, 0.749]

  it_behaves_like "basic single track",
    7.071, 7.071, 0, 0,
    [3.910, 3.910, 0.749, 0.749],
    [3.161, 3.161, 6.322, 6.322]


  # Not anchored at (0, 0)
  it_behaves_like "basic single track",
    10, 10, 10, 20,
    [10.000, 14.470, 10.000, 18.940],
    [10.000, 15.530, 10.000, 11.060]

  it_behaves_like "basic single track",
    10, 20, 10, 10,
    [10.000, 15.530, 10.000, 11.060],
    [10.000, 14.470, 10.000, 18.940]

  it_behaves_like "basic single track",
    10, 10, 20, 10,
    [14.470, 10.000, 18.940, 10.000],
    [15.530, 10.000, 11.060, 10.000]

  it_behaves_like "basic single track",
    20, 10, 10, 10,
    [15.530, 10.000, 11.060, 10.000],
    [14.470, 10.000, 18.940, 10.000]


  # Not anchored at 0,0 and out on two axis.
  it_behaves_like "basic single track",
    10, 10, 17.071, 17.071,
    [13.161, 13.161, 16.322, 16.322],
    [13.910, 13.910, 10.749, 10.749]

  it_behaves_like "basic single track",
    17.071, 17.071, 10, 10,
    [13.910, 13.910, 10.749, 10.749],
    [13.161, 13.161, 16.322, 16.322]

end
